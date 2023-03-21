# frozen_string_literal: true

require "increase/resource"

module Increase
  class AchPrenotifications < Resource
    NAME = "ACH Prenotifications"
    API_NAME = "ach_prenotifications"

    # Create an ACH Prenotification
    create
    # List ACH Prenotifications
    list
    # Retrieve an ACH Prenotification
    retrieve
  end
end
