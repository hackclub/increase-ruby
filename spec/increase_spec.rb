# frozen_string_literal: true

RSpec.describe Increase do
  it "has a version number" do
    expect(Increase::VERSION).not_to be nil
  end

  it "has a default client" do
    expect(Increase).to respond_to(:default_client)
  end

  it "has an increase_url" do
    expect(Increase).to respond_to(:increase_url)
    expect(Increase).to respond_to(:increase_url=)
  end

  it "has an increase_api_key" do
    expect(Increase).to respond_to(:increase_api_key)
    expect(Increase).to respond_to(:increase_api_key=)
  end

end
