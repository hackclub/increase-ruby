# frozen_string_literal: true

require "increase/resource"

module Increase
  class CheckTransfers < Resource
    create
    list
    retrieve
    endpoint :approve, :post, with: :id
    endpoint :cancel, :post, with: :id
    endpoint :stop_payment, :post, with: :id
  end
end
