# frozen_string_literal: true

require_relative "lib/increase/version"

Gem::Specification.new do |spec|
  spec.name = "increase"
  spec.version = Increase::VERSION
  spec.authors = ["Gary Tou"]
  spec.email = ["gary@garytou.com"]

  spec.summary = "An Increase.com Ruby client library"
  spec.description = "Ruby API client for Increase, a platform for Bare-Metal Banking APIs"
  spec.homepage = "https://github.com/garyhtou/increase-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.4"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/garyhtou/increase-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/garyhtou/increase-ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/console test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", "~> 2.7"
  spec.add_runtime_dependency "faraday-follow_redirects", "0.3.0"
  spec.add_runtime_dependency "faraday-multipart", "~> 1.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "erb"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
