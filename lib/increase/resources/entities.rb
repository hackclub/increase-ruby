# frozen_string_literal: true

require "increase/resource"

module Increase
  class Entities < Resource
    NAME = "Entities"
    RESOURCE_TYPE = "entities"

    # Create an Entity
    create
    # List Entities
    list
    # Retrieve an Entity
    retrieve
    # Create a supplemental document for an Entity
    endpoint :supplemental_documents, :post, path: [:entity_id, "supplemental_documents"]
  end
end
