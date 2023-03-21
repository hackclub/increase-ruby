# frozen_string_literal: true

require "increase/resource"

module Increase
  class Groups < Resource
    NAME = "Groups"
    RESOURCE_TYPE = "groups"

    # Retrieve Group details
    endpoint :current, :get, path: "current"
  end
end
