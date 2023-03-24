# frozen_string_literal: true

require "faraday"

module Increase
  module Middleware
    # JSON request middleware for Faraday 1.0
    # In Faraday 2.0, the JSON middleware is bundled with the Faraday gem itself
    #
    # This middleware is from
    # https://github.com/lostisland/faraday_middleware/blob/main/lib/faraday_middleware/request/encode_json.rb
    class EncodeJson < Faraday::Middleware
      CONTENT_TYPE = "Content-Type"
      MIME_TYPE = "application/json"
      MIME_TYPE_REGEX = %r{^application/(vnd\..+\+)?json$}.freeze

      dependency do
        require "json" unless defined?(::JSON)
      end

      def call(env)
        match_content_type(env) do |data|
          env[:body] = encode data
        end
        @app.call env
      end

      def encode(data)
        ::JSON.generate data
      end

      def match_content_type(env)
        return unless process_request?(env)

        env[:request_headers][CONTENT_TYPE] ||= MIME_TYPE
        yield env[:body] unless env[:body].respond_to?(:to_str)
      end

      def process_request?(env)
        type = request_type(env)
        has_body?(env) && (type.empty? || MIME_TYPE_REGEX =~ type)
      end

      def has_body?(env)
        (body = env[:body]) && !(body.respond_to?(:to_str) && body.empty?)
      end

      def request_type(env)
        type = env[:request_headers][CONTENT_TYPE].to_s
        type = type.split(";", 2).first if type.index(";")
        type
      end
    end
  end
end

Faraday::Request.register_middleware(json: Increase::Middleware::EncodeJson)
