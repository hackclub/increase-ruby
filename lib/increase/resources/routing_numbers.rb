# frozen_string_literal: true

require "increase/resource"

module Increase
  class RoutingNumbers < Resource
    NAME = "Routing Numbers"
    API_NAME = "routing_numbers"

    # List Routing Numbers
    list
  end
end
