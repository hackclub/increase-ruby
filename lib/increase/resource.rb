require "increase/response_hash"

module Increase
  class Resource
    def initialize(client: nil)
      if instance_of?(Resource)
        raise NotImplementedError, "Resource is an abstract class. You should perform actions on its subclasses (Accounts, Transactions, Card, etc.)"
      end
      @client = client || Increase.default_client
    end

    def self.with_config(config)
      if config.is_a?(Client)
        new(client: config)
      else
        new(client: Client.new(config))
      end
    end

    def self.resource_url
      "/#{self::RESOURCE_TYPE}"
    end

    def self.resource_name
      if self == Resource
        raise NotImplementedError, "Resource is an abstract class. You should perform actions on its subclasses (Accounts, Transactions, Card, etc.)"
      end

      name.split("::").last.gsub(/[A-Z]/, ' \0').strip
    end

    def self.endpoint(name, http_method, path: nil, with: nil)
      path = [path].flatten.compact
      with = [with].flatten.compact

      # TODO: This doesn't support multiple path params
      is_id = ->(path_segment) { path_segment.is_a?(Symbol) && path_segment.to_s.end_with?("_id") }
      has_id = path.any? is_id

      request_method = :request
      request_method = :paginated_request if with.include?(:pagination)

      method =
        if has_id
          # Method signature with a required `id` param
          ->(id, params = nil, headers = nil, &block) do
            segments = path.map { |segment| is_id.call(segment) ? id : segment }
            url = ([self.class.resource_url] + segments).join("/")

            send(request_method, http_method, url, params, headers, &block)
          end
        else
          # Method signature without a required `id` param
          ->(params = nil, headers = nil, &block) do
            url = ([self.class.resource_url] + path).join("/")

            send(request_method, http_method, url, params, headers, &block)
          end
        end

      # Define instance method
      define_method(name, &method)

      # Define class method (uses default config by calling `new`)
      define_singleton_method(name) do |*args, &block|
        new.send(name, *args, &block)
      end
    end

    private_class_method :endpoint

    class << self
      private

      # These methods here are shortcuts for the `endpoint` method. They define
      # commonly used endpoints. For example, nearly all resources have a `list`
      # endpoint which is a `GET` request to the resource's root URL.

      def create
        endpoint :create, :post
      end

      def list
        endpoint :list, :get, with: :pagination
      end

      def update
        endpoint :update, :patch
      end

      def retrieve
        endpoint :retrieve, :get
      end
    end

    # def self.endpoint_action(method, http_method)
    #   define_singleton_method(method) do |*args, &block|
    #     new.send(:action, method, http_method, *args, &block)
    #   end
    #
    #   define_method(method) do |*args, &block|
    #     new.send(:action, method, http_method, *args, &block)
    #   end
    # end
    #
    # private_class_method :endpoint_action
    #
    # private
    #
    # def create(params = nil, headers = nil)
    #   request(:post, self.class.resource_url, params, headers)
    # end
    #
    # def list(params = nil, headers = nil, &block)
    #   results = []
    #   count = 0
    #   limit = params&.[](:limit) || params&.[]("limit")
    #   if limit == :all || limit&.>(100)
    #     params&.delete(:limit)
    #     params&.delete("limit")
    #   end
    #
    #   loop do
    #     res = request(:get, self.class.resource_url, params, headers)
    #     data = res["data"]
    #     count += data.size
    #     if ![nil, :all].include?(limit) && count >= limit
    #       data = data[0..(limit - (count - data.size) - 1)]
    #     end
    #
    #     if block
    #       block.call(data)
    #     else
    #       results += data
    #     end
    #
    #     if limit.nil? || (limit != :all && count >= limit) || res["next_cursor"].nil?
    #       if block
    #         break
    #       else
    #         return results
    #       end
    #     end
    #
    #     params = (params || {}).merge({ cursor: res["next_cursor"] })
    #   end
    # end
    #
    # def update(id, params = nil, headers = nil)
    #   raise Error, "id must be a string" unless id.is_a?(String)
    #   path = "#{self.class.resource_url}/#{id}"
    #   request(:patch, path, params, headers)
    # end
    #
    # def retrieve(id, params = nil, headers = nil)
    #   raise Error, "id must be a string" unless id.is_a?(String)
    #   path = "#{self.class.resource_url}/#{id}"
    #   request(:get, path, params, headers)
    # end
    #
    # # Such as for "/accounts/{account_id}/close"
    # # "close" is the action.
    # def action(action, http_method, id, params = nil, headers = nil)
    #   raise Error, "id must be a string" unless id.is_a?(String)
    #   path = "#{self.class.resource_url}/#{id}/#{action}"
    #   request(http_method, path, params, headers)
    # end

    private

    def request(method, path, params = nil, headers = nil, &block)
      if block
        # Assume the caller wants to automatically paginate
        return paginated_request(method, path, params, headers, &block)
      end

      if method == :post
        headers = {"Content-Type" => "application/json"}.merge!(headers || {})
      end

      response = @client.connection.send(method, path, params, headers)
      ResponseHash.new(response.body, response: response)
    end

    def paginated_request(method, path, params = nil, headers = nil, &block)
      results = []
      count = 0
      limit = params&.[](:limit) || params&.[]("limit")
      if limit == :all || limit&.>(100)
        params&.delete(:limit)
        params&.delete("limit")
      end

      loop do
        res = request(method, path, params, headers)
        data = res["data"]

        # Handle case where endpoint doesn't actually support pagination.
        # For example, someone passes a block to `Account.create`
        if data.nil?
          # In this case, we'll both yield and return the response
          yield res if block
          return res
        end

        count += data.size
        if ![nil, :all].include?(limit) && count >= limit
          data = data[0..(limit - (count - data.size) - 1)]
        end

        if block
          block.call(data)
        else
          results += data
        end

        if limit.nil? || (limit != :all && count >= limit) || res["next_cursor"].nil?
          if block
            break
          else
            return results
          end
        end

        params = (params || {}).merge({cursor: res["next_cursor"]})
      end
    end
  end
end
