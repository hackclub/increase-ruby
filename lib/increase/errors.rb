# frozen_string_literal: true

module Increase
  class Error < StandardError; end

  class ApiError < Error
    attr_reader :response

    attr_reader :detail
    attr_reader :status
    attr_reader :title
    attr_reader :type

    def initialize(message, response: nil, detail: nil, status: nil, title: nil, type: nil)
      @response = response

      @detail = detail || response.body["detail"]
      @status = status || response.body["status"]
      @title = title || response.body["title"]
      @type = type || response.body["type"]

      super(message)
    end

    class << self
      def from_response(response)
        type = response.body["type"]
        klass = ERROR_TYPES[type]

        # Fallback in case of really bad 5xx error
        klass ||= InternalServerError if (500..599).cover?(response.status)

        # Handle case of an unknown error
        klass ||= ApiError

        code = [response.body["status"] || response.status, type].compact.join(": ") || "Error"
        message = [response.body["title"], response.body["detail"]].compact.join(" ") || "Increase API Error"

        klass.new("[#{code}] #{message}", response: response)
      end
    end
  end

  class ApiMethodNotFoundError < ApiError; end

  class EnvironmentMismatchError < ApiError; end

  class IdempotencyConflictError < ApiError; end

  class IdempotencyUnprocessableError < ApiError; end

  class InsufficientPermissionsError < ApiError; end

  class InternalServerError < ApiError; end

  class InvalidApiKeyError < ApiError; end

  class InvalidOperationError < ApiError; end

  class InvalidParametersError < ApiError; end

  class MalformedRequestError < ApiError; end

  class ObjectNotFoundError < ApiError; end

  class PrivateFeatureError < ApiError; end

  class RateLimitedError < ApiError; end

  ERROR_TYPES = {
    "api_method_not_found_error" => ApiMethodNotFoundError,
    "environment_mismatch_error" => EnvironmentMismatchError,
    "idempotency_conflict_error" => IdempotencyConflictError,
    "idempotency_unprocessable_error" => IdempotencyUnprocessableError,
    "insufficient_permissions_error" => InsufficientPermissionsError,
    "internal_server_error" => InternalServerError,
    "invalid_api_key_error" => InvalidApiKeyError,
    "invalid_operation_error" => InvalidOperationError,
    "invalid_parameters_error" => InvalidParametersError,
    "malformed_request_error" => MalformedRequestError,
    "object_not_found_error" => ObjectNotFoundError,
    "private_feature_error" => PrivateFeatureError,
    "rate_limited_error" => RateLimitedError
  }
end
