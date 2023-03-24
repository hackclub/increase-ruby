# frozen_string_literal: true

require "faraday"
require "json"

module Increase
  module Middleware
    # JSON response middleware for Faraday 1.0
    # In Faraday 2.0, the JSON middleware is bundled with the Faraday gem itself
    #
    # This middleware is from
    # https://github.com/jsmestad/jsonapi-consumer/blob/7d9721ea7feb888ea1e43edb9f1c0c38334762ed/lib/jsonapi/consumer/middleware/parse_json.rb
    class ParseJson < Faraday::Middleware
      def call(environment)
        @app.call(environment).on_complete do |env|
          if process_response_type?(response_type(env))
            env[:raw_body] = env[:body]
            env[:body] = parse(env[:body])
          end
        end
      end

      private

      def parse(body)
        ::JSON.parse(body) unless body.strip.empty?
      end

      def response_type(env)
        type = env[:response_headers]["Content-Type"].to_s
        type = type.split(";", 2).first if type.index(";")
        type
      end

      def process_response_type?(type)
        !!type.match(/\bjson$/)
      end
    end
  end
end

Faraday::Response.register_middleware(json: Increase::Middleware::ParseJson)
