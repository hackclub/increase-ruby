# frozen_string_literal: true

require "increase/resource"

module Increase
  class PendingTransactions < Resource
    list
    retrieve
  end
end
