module Increase
  module Util
    # Constant time string comparison to prevent timing attacks
    # Code borrowed from `stripe-ruby`, which was borrowed from ActiveSupport
    def self.secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res.zero?
    end
  end
end
