# frozen_string_literal: true

RSpec.describe Increase::Configuration do
  context "when configured with a block" do
    before do
      @configuration = Increase::Configuration.new
      @configuration.configure do |config|
        config.base_url = "https://example.com"
      end
    end

    it "sets the configuration" do
      expect(@configuration.base_url).to eq("https://example.com")
    end
  end

  context "when configured with a hash" do
    before do
      @configuration = Increase::Configuration.new
      @configuration.configure(base_url: "https://example.com")
    end

    it "sets the configuration" do
      expect(@configuration.base_url).to eq("https://example.com")
    end
  end

  context "when base_url is set to :production" do
    before do
      @configuration = Increase::Configuration.new
      @configuration.base_url = :production
    end

    it "sets the base_url to Increase::PRODUCTION_URL" do
      expect(@configuration.base_url).to eq(Increase::PRODUCTION_URL)
    end
  end

  context "when base_url is set to :sandbox" do
    before do
      @configuration = Increase::Configuration.new
      @configuration.base_url = :sandbox
    end

    it "sets the base_url to Increase::SANDBOX_URL" do
      expect(@configuration.base_url).to eq(Increase::SANDBOX_URL)
    end
  end

end
