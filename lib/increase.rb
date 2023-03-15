# frozen_string_literal: true

require "increase/version"
require "increase/configuration"

module Increase
  PRODUCTION_URL = "https://api.increase.com"
  SANDBOX_URL = "https://sandbox.increase.com"

  @configuration = Configuration.new

  class << self
    attr_accessor :configuration

    def configure
      yield configuration
    end

  end
end
