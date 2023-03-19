module Increase
  class ResponseHash < Hash
    attr_reader :response

    def initialize(hash, response: nil)
      @response = response
      merge!(hash)
    end

    # https://increase.com/documentation/api#idempotency
    def idempotent_replayed
      response.headers["Idempotent-Replayed"]
    end
  end
end
