# frozen_string_literal: true

require "increase/resource"

module Increase
  class CheckDeposits < Resource
    NAME = "Check Deposits"
    API_NAME = "check_deposits"

    # Create a Check Deposit
    create
    # List Check Deposits
    list
    # Retrieve a Check Deposit
    retrieve
  end
end
