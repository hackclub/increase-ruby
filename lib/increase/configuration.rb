# frozen_string_literal: true

module Increase

  class Configuration
    attr_reader :increase_url
    attr_accessor :increase_api_key
    attr_accessor :raise_api_errors
    # TODO: support Faraday config

    def initialize
      reset
    end

    def reset
      @increase_url = Increase::PRODUCTION_URL
      @increase_api_key = nil
      @raise_api_errors = true
    end

    def configure(config = nil)
      if config.is_a?(Hash)
        config.each do |key, value|
          self.public_send("#{key}=", value)
        end
      end

      if block_given?
        yield self
      end
    end

    def increase_url=(url)
      url = PRODUCTION_URL if url == :production
      url = SANDBOX_URL if [:sandbox, :development].include?(url)

      # Validate url
      unless url =~ URI::regexp(%w[http https])
        raise ArgumentError, "Invalid url: #{url}"
      end

      @increase_url = url
    end
  end
end
