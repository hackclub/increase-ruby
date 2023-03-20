# frozen_string_literal: true

require "increase/resource"

module Increase
  class AccountTransfers < Resource
    create
    list
    retrieve
    endpoint :approve, :post, with: :id
    endpoint :cancel, :post, with: :id
  end
end
