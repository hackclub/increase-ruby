# frozen_string_literal: true

require "increase/resource"

module Increase
  class Events < Resource
    list
    retrieve
  end
end
