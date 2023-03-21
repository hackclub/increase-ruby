# frozen_string_literal: true

require "increase/resource"

module Increase
  class Transactions < Resource
    NAME = "Transactions"
    API_NAME = "transactions"

    # List Transactions
    list
    # Retrieve a Transaction
    retrieve
  end
end
