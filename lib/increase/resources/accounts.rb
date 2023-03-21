# frozen_string_literal: true

require "increase/resource"

module Increase
  class Accounts < Resource
    RESOURCE_TYPE = "accounts"

    # Create an Account
    create
    # List Accounts
    list
    # Update an Account
    update
    # Retrieve an Account
    retrieve
    # Close an Account
    endpoint :close, :post, path: [:account_id, "close"]
  end
end
