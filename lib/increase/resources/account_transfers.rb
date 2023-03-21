# frozen_string_literal: true

require "increase/resource"

module Increase
  class AccountTransfers < Resource
    RESOURCE_TYPE = "account_transfers"

    # Create an Account Transfer
    create
    # List Account Transfers
    list
    # Retrieve an Account Transfer
    retrieve
    # Approve an Account Transfer
    endpoint :approve, :post, path: [:account_transfer_id, "approve"]
    # Cancel an Account Transfer
    endpoint :cancel, :post, path: [:account_transfer_id, "cancel"]
  end
end
