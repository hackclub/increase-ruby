# frozen_string_literal: true

module Increase
  class Configuration
    attr_reader :base_url
    attr_accessor :api_key
    attr_accessor :raise_api_errors
    # TODO: support Faraday config

    def initialize(config = nil)
      if config.nil?
        reset
      else
        configure(config)
      end
    end

    def reset
      @base_url = Increase::PRODUCTION_URL || ENV["INCREASE_BASE_URL"]
      @api_key = nil || ENV["INCREASE_API_KEY"]
      @raise_api_errors = true
    end

    def configure(config = nil)
      if config.is_a?(Hash)
        config.each do |key, value|
          unless respond_to?("#{key}=")
            raise Error, "Invalid configuration key: #{key}"
          end
          public_send("#{key}=", value)
        end
      end

      if block_given?
        yield self
      end

      self
    end

    def base_url=(url)
      url = PRODUCTION_URL if url == :production
      url = SANDBOX_URL if [:sandbox, :development].include?(url)

      # Validate url
      unless url&.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
        raise ArgumentError, "Invalid url: #{url}"
      end

      @base_url = url
    end
  end
end
