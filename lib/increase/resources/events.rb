# frozen_string_literal: true

require "increase/resource"

module Increase
  class Events < Resource
    NAME = "Events"
    RESOURCE_TYPE = "events"

    # List Events
    list
    # Retrieve an Event
    retrieve
  end
end
