# frozen_string_literal: true

require "increase/resource"

module Increase
  class CardDisputes < Resource
    NAME = "Card Disputes"
    RESOURCE_TYPE = "card_disputes"

    # Create a Card Dispute
    create
    # List Card Disputes
    list
    # Retrieve a Card Dispute
    retrieve
  end
end
