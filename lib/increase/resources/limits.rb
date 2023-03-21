# frozen_string_literal: true

require "increase/resource"

module Increase
  class Limits < Resource
    NAME = "Limits"
    RESOURCE_TYPE = "limits"

    # Create a Limit
    create
    # List Limits
    list
    # Update a Limit
    update
    # Retrieve a Limit
    retrieve
  end
end
