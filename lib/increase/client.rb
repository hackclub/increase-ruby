# frozen_string_literal: true

require "increase/configuration"
require "increase/middleware/raise_api_error"

require "faraday"
require "faraday/follow_redirects"
require "faraday/multipart"


module Increase
  class Client
    extend Forwardable

    attr_accessor :configuration
    def_delegators :configuration, :configure

    def_delegators :configuration, :base_url, :base_url=
    def_delegators :configuration, :api_key, :api_key=
    def_delegators :configuration, :raise_api_errors, :raise_api_errors=

    def initialize(config = nil)
      @configuration = config.is_a?(Configuration) ? config : Configuration.new(config)
    end

    def connection
      Faraday.new(
        url: @configuration.base_url,
        headers: {
          Authorization: "Bearer #{@configuration.api_key}",
          "User-Agent": "Increase Ruby Gem v#{Increase::VERSION} (https://github.com/garyhtou/increase-ruby)"
        }
      ) do |f|
        f.request :json
        f.request :multipart

        if @configuration.raise_api_errors
          # This custom middleware for raising Increase API errors must be
          # located before the JSON response middleware.
          f.use Increase::Middleware::RaiseApiError
        end

        f.response :json
        f.response :follow_redirects
        f.adapter Faraday.default_adapter
      end
    end
  end
end
