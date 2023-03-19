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
      "/#{resource_name.downcase.tr(" ", "_")}"
    end

    def self.resource_name
      if self == Resource
        raise NotImplementedError, "Resource is an abstract class. You should perform actions on its subclasses (Accounts, Transactions, Card, etc.)"
      end

      name.split("::").last.gsub(/[A-Z]/, ' \0').strip
    end

    def self.endpoint(method, as: nil, with: nil)
      if as == :action
        raise Error, "`with` must be a valid HTTP method" unless %i[get post put patch delete].include?(with)
        return endpoint_action(method, with)
      end
      raise Error, "as must be :action" if as

      define_singleton_method(method) do |*args, &block|
        new.send(method, *args, &block)
      end

      public method
    end

    private_class_method :endpoint

    def self.endpoint_action(method, http_method)
      define_singleton_method(method) do |*args, &block|
        new.send(:action, method, http_method, *args, &block)
      end

      define_method(method) do |*args, &block|
        new.send(:action, method, http_method, *args, &block)
      end
    end

    private_class_method :endpoint_action

    private

    def create(params = nil, headers = nil)
      request(:post, self.class.resource_url, params, headers)
    end

    def list(params = nil, headers = nil, &block)
      results = []
      count = 0
      limit = params&.[](:limit) || params&.[]("limit")
      if limit == :all || limit&.>(100)
        params&.delete(:limit)
        params&.delete("limit")
      end

      loop do
        res = request(:get, self.class.resource_url, params, headers)
        data = res["data"]
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

    def update(id, params = nil, headers = nil)
      raise Error, "id must be a string" unless id.is_a?(String)
      path = "#{self.class.resource_url}/#{id}"
      request(:patch, path, params, headers)
    end

    def retrieve(id, params = nil, headers = nil)
      raise Error, "id must be a string" unless id.is_a?(String)
      path = "#{self.class.resource_url}/#{id}"
      request(:get, path, params, headers)
    end

    # Such as for "/accounts/{account_id}/close"
    # "close" is the action.
    def action(action, http_method, id, params = nil, headers = nil)
      raise Error, "id must be a string" unless id.is_a?(String)
      path = "#{self.class.resource_url}/#{id}/#{action}"
      request(http_method, path, params, headers)
    end

    def request(method, path, params = nil, headers = nil)
      if method == :post
        headers = {"Content-Type" => "application/json"}.merge!(headers || {})
      end

      response = @client.connection.send(method, path, params, headers)
      ResponseHash.new(response.body, response: response)
    end
  end
end
