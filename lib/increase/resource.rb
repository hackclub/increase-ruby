require "increase/response_hash"
require "increase/response_array"

module Increase
  class Resource
    PAGINATION_MAX_LIMIT = 100

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
      "/#{self::API_NAME}"
    end

    def self.endpoint(name, http_method, path: nil, with: nil)
      path = [path].flatten.compact
      with = [with].flatten.compact

      # TODO: This doesn't support multiple path params
      is_id = ->(path_segment) { path_segment.is_a?(Symbol) && path_segment.to_s.end_with?('id') }
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
        endpoint :update, :patch, path: [:id]
      end

      def retrieve
        endpoint :retrieve, :get, path: [:id]
      end
    end

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
      params ||= {}
      limit = params[:limit] || params["limit"]
      if limit == :all || limit&.>(PAGINATION_MAX_LIMIT)
        # Request `limit` can not be greater than `PAGINATION_MAX_LIMIT`
        params.delete("limit")
        params[:limit] = PAGINATION_MAX_LIMIT
      end

      results = []
      count = 0

      loop do
        res = request(method, path, params, headers)
        data = res["data"]

        # Handle case where endpoint doesn't support pagination.
        # For example, someone passes a block to `Accounts.create`
        if data.nil?
          # In this case, we'll both yield and return the response.
          # `res` here is already a `ResponseHash` since it comes from `request`
          if block
            yield res and return
          end
          return res
        end

        # From here on, the endpoint definitely supports pagination

        count += data.size
        # Restrict number of results to the limit
        if ![nil, :all].include?(limit) && count >= limit
          data = data[0..(limit - (count - data.size) - 1)]
        end

        # Either yield or collect the results
        if block
          block.call(ResponseArray.new(data, full_response: res, response: res.response))
        else
          results += data
        end

        # Handle case where user doesn't want to paginate
        if limit.nil?
          if block
            # Block has already been called above
            return
          else
            return ResponseArray.new(results, full_response: res, response: res.response)
          end
        end

        # From here on, this is for sure a paginated request

        # Handle case where we've hit the last page
        if (limit != :all && count >= limit) || res["next_cursor"].nil?
          if block
            # We've already yielded all the data above
            return
          else
            # Wrap with a `ResponseArray`. However, there are multiple
            # requests/responses associated with this array. The `full_response`
            # and `response` only store the last response.
            return ResponseArray.new(results, full_response: res, response: res.response)
          end
        end

        # Update the cursor and loop again!
        params[:cursor] = res["next_cursor"]
        if limit != :all
          params[:limit] = [limit - count, PAGINATION_MAX_LIMIT].min
        end
      end
    end
  end
end
