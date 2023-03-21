# frozen_string_literal: true

require "increase/resource"

module Increase
  class AchPrenotifications < Resource
    RESOURCE_TYPE = "ach_prenotifications"

    # Create an ACH Prenotification
    create
    # List ACH Prenotifications
    list
    # Retrieve an ACH Prenotification
    retrieve
  end
end
