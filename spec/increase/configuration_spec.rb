# frozen_string_literal: true

RSpec.describe Increase::Configuration do
  context "when configured with a block" do
    before do
      @configuration = Increase::Configuration.new
      @configuration.configure do |config|
        config.increase_url = "https://example.com"
      end
    end

    it "sets the configuration" do
      expect(@configuration.increase_url).to eq("https://example.com")
    end
  end

  context "when configured with a hash" do
    before do
      @configuration = Increase::Configuration.new
      @configuration.configure(increase_url: "https://example.com")
    end

    it "sets the configuration" do
      expect(@configuration.increase_url).to eq("https://example.com")
    end
  end

  context "when increase_url is set to :production" do
    before do
      @configuration = Increase::Configuration.new
      @configuration.increase_url = :production
    end

    it "sets the increase_url to Increase::PRODUCTION_URL" do
      expect(@configuration.increase_url).to eq(Increase::PRODUCTION_URL)
    end
  end

  context "when increase_url is set to :sandbox" do
    before do
      @configuration = Increase::Configuration.new
      @configuration.increase_url = :sandbox
    end

    it "sets the increase_url to Increase::SANDBOX_URL" do
      expect(@configuration.increase_url).to eq(Increase::SANDBOX_URL)
    end
  end

end
