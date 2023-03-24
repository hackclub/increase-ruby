require "faraday"

module Increase
  module Middleware
    class RaiseApiError < Faraday::Middleware
      def on_complete(env)
        return if env[:status] < 400

        raise Increase::ApiError.from_response(env)
      end
    end
  end
end
