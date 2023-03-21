# frozen_string_literal: true

require "increase/resource"

module Increase
  class Transactions < Resource
    RESOURCE_TYPE = "transactions"

    # List Transactions
    list
    # Retrieve a Transaction
    retrieve
  end
end
