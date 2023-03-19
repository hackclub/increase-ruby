# frozen_string_literal: true

require "increase/resource"

module Increase
  class Events < Resource
    endpoint :list
    endpoint :retrieve
  end
end
