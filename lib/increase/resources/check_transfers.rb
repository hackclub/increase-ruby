# frozen_string_literal: true

require "increase/resource"

module Increase
  class CheckTransfers < Resource
    NAME = "Check Transfers"
    RESOURCE_TYPE = "check_transfers"

    # Create a Check Transfer
    create
    # List Check Transfers
    list
    # Retrieve a Check Transfer
    retrieve
    # Approve a Check Transfer
    endpoint :approve, :post, path: [:check_transfer_id, "approve"]
    # Cancel a pending Check Transfer
    endpoint :cancel, :post, path: [:check_transfer_id, "cancel"]
    # Request a stop payment on a Check Transfer
    endpoint :stop_payment, :post, path: [:check_transfer_id, "stop_payment"]
  end
end
