# frozen_string_literal: true

require "increase/resource"

module Increase
  class Accounts < Resource
    create
    list
    update
    retrieve
    endpoint :close, :post, with: :id
  end
end
