# frozen_string_literal: true

require "increase/resource"

module Increase
  class Transactions < Resource
    endpoint :list
    endpoint :retrieve
  end
end
