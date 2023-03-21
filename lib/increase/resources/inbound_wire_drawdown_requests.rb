# frozen_string_literal: true

require "increase/resource"

module Increase
  class InboundWireDrawdownRequests < Resource
    RESOURCE_TYPE = "inbound_wire_drawdown_requests"

    # List Inbound Wire Drawdown Requests
    list
    # Retrieve an Inbound Wire Drawdown Request
    retrieve
  end
end
