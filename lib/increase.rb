# frozen_string_literal: true

require "increase/version"
require "increase/client"
require "increase/configuration"
require "increase/errors"
require "increase/resources"

module Increase
  PRODUCTION_URL = "https://api.increase.com"
  SANDBOX_URL = "https://sandbox.increase.com"

  @default_client = Client.new

  class << self
    extend Forwardable

    attr_accessor :default_client
    def_delegators :default_client, :configure

    def_delegators :default_client, :increase_url, :increase_url=
    def_delegators :default_client, :increase_api_key, :increase_api_key=
    def_delegators :default_client, :raise_api_errors, :raise_api_errors=

  end
end
