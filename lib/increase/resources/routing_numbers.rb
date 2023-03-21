# frozen_string_literal: true

require "increase/resource"

module Increase
  class RoutingNumbers < Resource
    RESOURCE_TYPE = "routing_numbers"

    # List Routing Numbers
    list
  end
end
