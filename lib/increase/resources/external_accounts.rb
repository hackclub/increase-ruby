# frozen_string_literal: true

require "increase/resource"

module Increase
  class ExternalAccounts < Resource
    NAME = "External Accounts"
    API_NAME = "external_accounts"

    # Create an External Account
    create
    # List External Accounts
    list
    # Update an External Account
    update
    # Retrieve an External Account
    retrieve
  end
end
