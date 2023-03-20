# frozen_string_literal: true

require "increase/resource"

module Increase
  class Limits < Resource
    create
    list
    update
    retrieve
  end
end
