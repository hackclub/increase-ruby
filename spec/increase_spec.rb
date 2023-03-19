# frozen_string_literal: true

RSpec.describe Increase do
  it "has a version number" do
    expect(Increase::VERSION).not_to be nil
  end

  it "has a default client" do
    expect(Increase).to respond_to(:default_client)
  end

  it "has an base_url" do
    expect(Increase).to respond_to(:base_url)
    expect(Increase).to respond_to(:base_url=)
  end

  it "has an api_key" do
    expect(Increase).to respond_to(:api_key)
    expect(Increase).to respond_to(:api_key=)
  end

end
