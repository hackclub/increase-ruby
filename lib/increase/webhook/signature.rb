require "increase/util"
require "increase/errors"

module Increase
  # Keeping this module singular in case Increase adds a `webhooks` resource
  module Webhook
    module Signature
      DEFAULT_TIME_TOLERANCE = 300 # 300 seconds (5 minutes)
      DEFAULT_SCHEME = "v1"

      def self.verify?(payload:, signature_header:, secret:, scheme: DEFAULT_SCHEME, time_tolerance: DEFAULT_TIME_TOLERANCE)
        # Helper for raising errors with additional metadata
        sig_error = ->(msg) do
          WebhookSignatureVerificationError.new(msg, signature_header: signature_header, payload: payload)
        end

        # Parse header
        sig_values = signature_header.split(",").map { |pair| pair.split("=") }.to_h

        # Extract values
        t = sig_values["t"] # Should be a string (ISO-8601 timestamp)
        sig = sig_values[scheme]
        raise sig_error.call("No timestamp found in signature header") if t.nil?
        raise sig_error.call("No signature found with scheme #{scheme} in signature header") if sig.nil?

        # Check signature
        expected_sig = compute_signature(timestamp: t, payload: payload, secret: secret)
        matches = Util.secure_compare(expected_sig, sig)
        raise sig_error.call("Signature mismatch") unless matches

        # Check timestamp tolerance to prevent timing attacks
        if time_tolerance > 0
          begin
            timestamp = DateTime.parse(t)
            now = DateTime.now
            diff = (now - timestamp) * 24 * 60 * 60 # in seconds

            # Don't allow timestamps in the future
            if diff > time_tolerance || diff < 0
              raise sig_error.call("Timestamp outside of the tolerance zone")
            end
          rescue Date::Error
            raise sig_error.call("Invalid timestamp in signature header: #{t}")
          end
        end

        true
      end

      def self.compute_signature(timestamp:, payload:, secret:)
        signed_payload = timestamp.to_s + "." + payload.to_s
        OpenSSL::HMAC.hexdigest("SHA256", secret, signed_payload)
      end
    end
  end
end
