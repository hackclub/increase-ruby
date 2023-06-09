# frozen_string_literal: true

require "increase/resource"

module Increase
  class PendingTransactions < Resource
    NAME = "Pending Transactions"
    API_NAME = "pending_transactions"

    # List Pending Transactions
    list
    # Retrieve a Pending Transaction
    retrieve
  end
end
