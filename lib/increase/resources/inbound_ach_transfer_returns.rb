# frozen_string_literal: true

require "increase/resource"

module Increase
  class InboundAchTransferReturns < Resource
    NAME = "Inbound ACH Transfer Returns"
    RESOURCE_TYPE = "inbound_ach_transfer_returns"

    # Create an ACH Return
    create
    # List Inbound ACH Transfer Returns
    list
    # Retrieve an Inbound ACH Transfer Return
    retrieve
  end
end
