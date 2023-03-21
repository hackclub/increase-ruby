# frozen_string_literal: true

require "increase/resource"

module Increase
  class Limits < Resource
    NAME = "Limits"
    API_NAME = "limits"

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
