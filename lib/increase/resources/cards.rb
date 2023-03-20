# frozen_string_literal: true

require "increase/resource"

module Increase
  class Cards < Resource
    create
    list
    endpoint :details, :get, with: :id
    update
    retrieve
  end
end
