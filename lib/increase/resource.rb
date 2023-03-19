require "increase/response_hash"

module Increase
  class Resource
    def initialize(client: nil)
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
      "/#{resource_name.downcase}"
    end

    def self.resource_name
      if self == Resource
        raise NotImplementedError, "Resource is an abstract class. You should perform actions on its subclasses (Accounts, Transactions, Card, etc.)"
      end

      name.split("::").last
    end

    def self.endpoint(method, as: nil)
      return endpoint_action(method) if as == :action
      raise Error, "as must be :action" if as

      define_singleton_method(method) do |*args|
        new.send(method, *args)
      end

      public method
    end

    private_class_method :endpoint

    def self.endpoint_action(method)
      define_singleton_method(method) do |*args|
        new.send(:action, method, *args)
      end

      define_method(method) do |*args|
        new.send(:action, method, *args)
      end
    end

    private_class_method :endpoint_action

    private

    def create(params = nil, headers = nil)
      request(:post, self.class.resource_url, params, headers)
    end

    def list(params = nil, headers = nil)
      request(:get, self.class.resource_url, params, headers)
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
    def action(action, id, params = nil, headers = nil)
      raise Error, "id must be a string" unless id.is_a?(String)
      path = "#{self.class.resource_url}/#{id}/#{action}"
      request(:post, path, params, headers)
    end

    def request(method, path, params = nil, headers = nil)
      if method == :post
        headers = { "Content-Type" => "application/json" }.merge!(headers || {})
      end

      response = @client.connection.send(method, path, params, headers)
      ResponseHash.new(response.body, response: response)
    end
  end
end
