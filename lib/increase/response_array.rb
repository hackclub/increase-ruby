module Increase
  class ResponseArray < Array
    attr_reader :response

    def initialize(array, full_response: nil, response: nil)
      @full_response = full_response
      @response = response
      super(array)
    end

    def wrapped
      @full_response
    end

    def next_cursor
      wrapped['next_cursor']
    end
  end
end
