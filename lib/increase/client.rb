# frozen_string_literal: true

require "increase/configuration"
require "increase/middleware/raise_api_error"

require "faraday"
require "faraday/follow_redirects" # Supports both Faraday 1.0 and 2.0
if Gem::Version.new(Faraday::VERSION) >= Gem::Version.new("2.0")
  # In Faraday 2.0, multipart support is no longer included by default
  require "faraday/multipart"
else
  # In Faraday 1.0, the JSON middleware is not included by default
  require "increase/middleware/encode_json"
  require "increase/middleware/parse_json"
end

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
