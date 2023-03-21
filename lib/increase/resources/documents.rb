# frozen_string_literal: true

require "increase/resource"

module Increase
  class Documents < Resource
    NAME = "Documents"
    API_NAME = "documents"

    # List Documents
    list
    # Retrieve a Document
    retrieve
  end
end
