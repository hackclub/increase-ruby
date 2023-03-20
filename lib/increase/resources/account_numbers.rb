# frozen_string_literal: true

require "increase/resource"

module Increase
  class AccountNumbers < Resource
    create
    list
    update
    retrieve
  end
end
