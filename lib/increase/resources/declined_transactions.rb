# frozen_string_literal: true

require "increase/resource"

module Increase
  class DeclinedTransactions < Resource
    NAME = "Declined Transactions"
    API_NAME = "declined_transactions"

    # List Declined Transactions
    list
    # Retrieve a Declined Transaction
    retrieve
  end
end
