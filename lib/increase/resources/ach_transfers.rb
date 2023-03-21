# frozen_string_literal: true

require "increase/resource"

module Increase
  class AchTransfers < Resource
    RESOURCE_TYPE = "ach_transfers"

    # Create an ACH Transfer
    create
    # List ACH Transfers
    list
    # Retrieve an ACH Transfer
    retrieve
    # Approve an ACH Transfer
    endpoint :approve, :post, path: [:ach_transfer_id, "approve"]
    # Cancel a pending ACH Transfer
    endpoint :cancel, :post, path: [:ach_transfer_id, "cancel"]
  end
end
