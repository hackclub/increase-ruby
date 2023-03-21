# frozen_string_literal: true

require "increase/resource"

module Increase
  class Files < Resource
    NAME = "Files"
    API_NAME = "files"

    # Create a File
    endpoint :create, :post, with: :file_upload
    # List Files
    list
    # Retrieve a File
    retrieve
  end
end
