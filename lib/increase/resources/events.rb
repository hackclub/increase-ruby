# frozen_string_literal: true

require "increase/resource"

module Increase
  class Events < Resource
    NAME = "Events"
    API_NAME = "events"

    # List Events
    list
    # Retrieve an Event
    retrieve
  end
end
