# frozen_string_literal: true

RSpec.describe Increase::Webhook::Signature do
  context "when verifying a signature" do
    before do
      @signature_header = "t=2023-03-20T03:31:09Z,v1=282dc888f529b473bbefef2f1c4256dc90a21cdbd575fc3cb1fcd5e9ff44fda5"
      @payload = <<~PAYLOAD
        {
          "associated_object_id": "sandbox_account_dopw79musawrxg323c6h",
          "associated_object_type": "account",
          "category": "account.created",
          "created_at": "2023-03-20T03:30:45Z",
          "id": "sandbox_event_001gvyh3grapy5n74tvzj783gfk",
          "type": "event"
        }
      PAYLOAD
      @secret = "banking"
    end

    it "verifies the signature" do
      expect(
        Increase::Webhook::Signature.verify?(
          payload: @payload,
          signature_header: @signature_header,
          secret: @secret,
          time_tolerance: 0 # Disable time tolerance checking
        )
      ).to eq(true)
    end

    context "with a timestamp outside of the tolerance" do
      it "raises an error" do
        expect {
          Increase::Webhook::Signature.verify?(
            payload: @payload,
            signature_header: @signature_header,
            secret: @secret
          )
        }.to raise_error(Increase::WebhookSignatureVerificationError)
      end
    end
  end
end
