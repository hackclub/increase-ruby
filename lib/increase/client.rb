# frozen_string_literal: true

require "increase/configuration"

require "faraday"
require "faraday/follow_redirects"

# Custom Faraday Middleware to handle raising errors
require "faraday/raise_increase_api_error"

module Increase
  class Client
    extend Forwardable

    attr_accessor :configuration
    def_delegators :configuration, :configure

    def_delegators :default_client, :base_url, :base_url=
    def_delegators :default_client, :api_key, :api_key=
    def_delegators :default_client, :raise_api_errors, :raise_api_errors=

    def initialize
      @configuration = Configuration.new
    end

    def connection
      Faraday.new(
        url: @configuration.base_url,
        headers: {
          Authorization: "Bearer #{@configuration.api_key}"
        }
      ) do |f|
        f.request :json

        if @configuration.raise_api_errors
          # This custom middleware for raising Increase API errors must be
          # located before the JSON response middleware.
          f.use FaradayMiddleware::RaiseIncreaseApiError
        end

        f.response :json
        f.response :follow_redirects
        f.adapter Faraday.default_adapter
      end
    end
  end
end
