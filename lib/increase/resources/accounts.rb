# frozen_string_literal: true

require "increase/resource"

module Increase
  class Accounts < Resource
    class << self
      def create(params)
        client.post(resource_url, params)
      end

      def list(params = {})
        client.get(resource_url, params)
      end
    end
  end
end
