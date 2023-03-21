# frozen_string_literal: true

require "increase/resource"

module Increase
  class OauthConnections < Resource
    NAME = "OAuth Connections"
    RESOURCE_TYPE = "oauth_connections"

    # List OAuth Connections
    list
    # Retrieve an OAuth Connection
    retrieve
  end
end
