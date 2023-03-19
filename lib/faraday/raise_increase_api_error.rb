require 'faraday'

module FaradayMiddleware
  class RaiseIncreaseApiError < Faraday::Middleware
    def on_complete(env)
      return if env[:status] < 400

      raise Increase::ApiError.from_response(env)
    end

  end
end