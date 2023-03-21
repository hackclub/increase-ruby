# frozen_string_literal: true

require "increase/resource"

module Increase
  class Cards < Resource
    NAME = "Cards"
    RESOURCE_TYPE = "cards"

    # Create a Card
    create
    # List Cards
    list
    # Retrieve sensitive details for a Card
    endpoint :details, :get, path: [:card_id, "details"]
    # Update a Card
    update
    # Retrieve a Card
    retrieve
  end
end
