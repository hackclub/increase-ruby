# frozen_string_literal: true

RSpec.describe Increase::Client do
  before do
    @client = Increase::Client.new
  end

  it "has a configuration" do
    expect(@client).to respond_to(:configuration)
  end

  it "can be configured" do
    expect(@client).to respond_to(:configure)
  end

  it "has a Faraday connection" do
    expect(@client.connection).to be_a(Faraday::Connection)
  end

  it "has an base_url" do
    expect(@client).to respond_to(:base_url)
    expect(@client).to respond_to(:base_url=)
  end

  it "has an api_key" do
    expect(@client).to respond_to(:api_key)
    expect(@client).to respond_to(:api_key=)
  end

  context "when configured to raise API errors" do
    before do
      @client.configure do |config|
        config.raise_api_errors = true
      end
    end

    context "and the API returns a 400" do
      before do
        stub_request(:get, "https://example.com")
          .to_return(status: 400, body: "", headers: {})
      end

      it "raises an error" do
        expect { @client.connection.get("https://example.com") }.to raise_error(Increase::ApiError)
      end
    end
  end
end
