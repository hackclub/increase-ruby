# frozen_string_literal: true

require "increase/resource"

module Increase
  class Cards < Resource
    endpoint :create
    endpoint :list
    endpoint :details, as: :action, with: :get
    endpoint :update
    endpoint :retrieve
  end
end
