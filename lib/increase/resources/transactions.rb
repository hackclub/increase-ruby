# frozen_string_literal: true

require "increase/resource"

module Increase
  class Transactions < Resource
    list
    retrieve
  end
end
