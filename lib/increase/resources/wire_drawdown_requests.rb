# frozen_string_literal: true

require "increase/resource"

module Increase
  class WireDrawdownRequests < Resource
    RESOURCE_TYPE = "wire_drawdown_requests"

    # Create a Wire Drawdown Request
    create
    # List Wire Drawdown Requests
    list
    # Retrieve a Wire Drawdown Request
    retrieve
  end
end
