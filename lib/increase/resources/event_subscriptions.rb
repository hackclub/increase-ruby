# frozen_string_literal: true

require "increase/resource"

module Increase
  class EventSubscriptions < Resource
    NAME = "Event Subscriptions"
    API_NAME = "event_subscriptions"

    # Create an Event Subscription
    create
    # List Event Subscriptions
    list
    # Update an Event Subscription
    update
    # Retrieve an Event Subscription
    retrieve
  end
end
