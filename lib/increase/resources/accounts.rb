# frozen_string_literal: true

require "increase/resource"

module Increase
  class Accounts < Resource
    endpoint :create
    endpoint :list
    endpoint :update
    endpoint :retrieve
    endpoint :close, as: :action
  end
end
