# frozen_string_literal: true

require "increase/resource"

module Increase
  class CardProfiles < Resource
    NAME = "Card Profiles"
    RESOURCE_TYPE = "card_profiles"

    # Create a Card Profile
    create
    # List Card Profiles
    list
    # Retrieve a Card Profile
    retrieve
  end
end
