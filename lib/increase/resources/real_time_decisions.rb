# frozen_string_literal: true

require "increase/resource"

module Increase
  class RealTimeDecisions < Resource
    RESOURCE_TYPE = "real_time_decisions"

    # Action a Real-Time Decision
    endpoint :action, :post, path: [:real_time_decision_id, "action"]
    # Retrieve a Real-Time Decision
    retrieve
  end
end
