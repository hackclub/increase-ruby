# frozen_string_literal: true

require "tempfile"
require "marcel"
require "faraday"
require "pathname"

module Increase
  class FileUpload
    attr_reader :file, :filename, :content_type

    def initialize(file_or_path, filename: nil, content_type: nil)
      @filename = filename
      @content_type = content_type

      if file_or_path.is_a?(File) || file_or_path.is_a?(Tempfile)
        @file = file_or_path
        @filename ||= File.basename(file_or_path.path)
      elsif file_or_path.is_a?(String)
        # Treat string as a filepath
        @file = File.open(file_or_path)
        @filename ||= File.basename(file_or_path)
      elsif file_or_path.respond_to?(:read)
        @file = Tempfile.new(default_filename)
        @file.write(file_or_path.read)
      else
        raise ArgumentError, "File or path required"
      end

      # Try to guess content type
      @content_type ||= Marcel::MimeType.for(@file, name: @filename)
      @filename ||= default_filename
    end

    def file_part
      if Gem::Version.new(Faraday::VERSION) >= Gem::Version.new("2.0")
        Faraday::Multipart::FilePart.new(
          @file,
          @content_type,
          @filename
        )
      else
        Faraday::FilePart.new(
          @file,
          @content_type,
          @filename
        )
      end
    end

    private

    def default_filename
      "file upload #{Time.now}"
    end
  end
end
