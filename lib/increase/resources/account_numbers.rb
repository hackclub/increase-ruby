# frozen_string_literal: true

require "increase/resource"

module Increase
  class AccountNumbers < Resource
    endpoint :create
    endpoint :list
    endpoint :update
    endpoint :retrieve
  end
end
