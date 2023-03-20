# frozen_string_literal: true

RSpec.describe Increase::Resource do
  it "has a resource_url" do
    expect(Increase::Accounts.resource_url).to eq("/accounts")
  end

  it "has a resource_name" do
    expect(Increase::Accounts.resource_name).to eq("Accounts")
  end

  context "when using `with_config`" do
    it "can can be instantiated" do
      @client = Increase::Client.new
      expect(Increase::Accounts.with_config(@client)).to be_a(Increase::Accounts)
    end

    it "uses the client passed in" do
      @client = Increase::Client.new(api_key: "test")
      @resource = Increase::Accounts.with_config(@client)

      expect(@resource.instance_variable_get(:@client)).to eq(@client)
    end
  end

  it "`endpoint` method is private" do
    expect(Increase::Accounts.private_methods).to include(:endpoint)
  end

  it "base class is abstract" do
    expect { Increase::Resource.new }.to raise_error(NotImplementedError)
  end
end
