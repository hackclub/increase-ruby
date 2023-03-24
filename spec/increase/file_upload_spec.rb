# frozen_string_literal: true

RSpec.describe Increase::FileUpload do
  context "when given a file" do
    before do
      @file = File.open(File.expand_path("../../../README.md", __FILE__))
    end

    it "should accept a file" do
      expect(Increase::FileUpload.new(@file).file).to eq(@file)
    end

    it "should accept a content type" do
      expect(Increase::FileUpload.new(@file, content_type: "text/plain").content_type).to eq("text/plain")
    end

    it "should accept a filename" do
      expect(Increase::FileUpload.new(@file, filename: "README.txt").filename).to eq("README.txt")
    end

    context "and no content type is given" do
      it "should guess the content type" do
        expect(Increase::FileUpload.new(@file).content_type).to eq("text/markdown")
      end
    end

    after do
      @file.close
    end
  end

  context "when given a filepath" do
    before do
      @filepath = __FILE__ # Pass in this rspec ruby file
    end

    it "should accept a string" do
      expect(Increase::FileUpload.new(@filepath).file.read).to eq(File.read(@filepath))
    end

    it "should accept a content type" do
      expect(Increase::FileUpload.new(@filepath, content_type: "text/x-ruby").content_type).to eq("text/x-ruby")
    end

    it "should accept a filename" do
      expect(Increase::FileUpload.new(@filepath, filename: "test.rb").filename).to eq("test.rb")
    end

    context "and no content type is given" do
      it "should guess the content type" do
        expect(Increase::FileUpload.new(@filepath).content_type).to eq("text/x-ruby")
      end
    end
  end

  context "when given an IO" do
    before do
      @blob = Class.new do
        def read
          "Hello World"
        end
      end.new
    end

    it "should accept an IO" do
      expect(Increase::FileUpload.new(@blob).file.read).to eq(@blob.read)
    end

    it "should accept an content type" do
      expect(Increase::FileUpload.new(@blob, content_type: "text/plain").content_type).to eq("text/plain")
    end
  end
end
