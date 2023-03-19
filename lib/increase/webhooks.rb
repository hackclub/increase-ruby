require "openssl"
require "securecompare"

module Increase
  class Webhooks
    def self.verify?(payload:, signature_header:, secret:, scheme: "v1")
      sig_values = signature_header.split(",").map { |pair| pair.split("=") }
      sig_values = sig_values.to_h

      signed_payload = sig_values["t"] + "." + payload.to_s

      expected_sig = OpenSSL::HMAC.hexdigest("SHA256", secret, signed_payload)
      SecureCompare.compare(expected_sig, sig_values["v1"])
    end
  end
end
