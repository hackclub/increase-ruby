# frozen_string_literal: true

require "increase/resource"

module Increase
  class AccountStatements < Resource
    NAME = "Account Statements"
    API_NAME = "account_statements"

    # List Account Statements
    list
    # Retrieve an Account Statement
    retrieve
  end
end
