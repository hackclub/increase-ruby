# frozen_string_literal: true

require "increase/resource"

module Increase
  class WireTransfers < Resource
    RESOURCE_TYPE = "wire_transfers"

    # Create a Wire Transfer
    create
    # List Wire Transfers
    list
    # Retrieve a Wire Transfer
    retrieve
    # Approve a Wire Transfer
    endpoint :approve, :post, path: [:wire_transfer_id, "approve"]
    # Cancel a pending Wire Transfer
    endpoint :cancel, :post, path: [:wire_transfer_id, "cancel"]
  end
end
