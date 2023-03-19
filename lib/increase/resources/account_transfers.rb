# frozen_string_literal: true

require "increase/resource"

module Increase
  class AccountTransfers < Resource
    endpoint :create
    endpoint :list
    endpoint :retrieve
    endpoint :approve, as: :action, with: :post
    endpoint :cancel, as: :action, with: :post
  end
end
