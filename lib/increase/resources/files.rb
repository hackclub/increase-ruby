# frozen_string_literal: true

require "increase/resource"

module Increase
  class Files < Resource
    RESOURCE_TYPE = "files"

    # Create a File
    create
    # List Files
    list
    # Retrieve a File
    retrieve
  end
end
