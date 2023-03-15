# frozen_string_literal: true

module Increase

  class Configuration
    attr_reader :increase_url

    attr_accessor :increase_api_key

    def initialize
      reset
    end

    def reset
      @increase_url = PRODUCTION_URL
      @increase_api_key = nil
    end

    def increase_url=(url)
      url = PRODUCTION_URL if url == :production
      url = SANDBOX_URL if url == :sandbox

      # Validate url
      unless url =~ URI::regexp(%w[http https])
        raise ArgumentError, "Invalid url: #{url}"
      end

      @increase_url = url
    end
  end
end
