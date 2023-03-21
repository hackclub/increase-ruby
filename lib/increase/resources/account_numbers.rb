# frozen_string_literal: true

require "increase/resource"

module Increase
  class AccountNumbers < Resource
    RESOURCE_TYPE = "account_numbers"

    # Create an Account Number
    create
    # List Account Numbers
    list
    # Update an Account Number
    update
    # Retrieve an Account Number
    retrieve
  end
end
