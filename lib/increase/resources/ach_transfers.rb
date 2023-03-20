# frozen_string_literal: true

require "increase/resource"

module Increase
  class AchTransfers < Resource
    create
    list
    retrieve
    endpoint :approve, :post, with: :id
    endpoint :cancel, :post, with: :id
  end
end
