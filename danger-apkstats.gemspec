# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "apkstats/gem_version.rb"

Gem::Specification.new do |spec|
  spec.name          = "danger-apkstats"
  spec.version       = Apkstats::VERSION
  spec.authors       = ["Jumpei Matsuda"]
  spec.email         = ["jmatsu.drm@gmail.com"]
  spec.description   = "To inpsect android application file with danger."
  spec.summary       = "This is a danger plugin to inspect android application file."
  spec.homepage      = "https://github.com/jmatsu/danger-apkstats"
  spec.license       = "MIT"

  spec.files         = `git ls-files | grep -v 'fixture/'`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "danger-plugin-api", "~> 1.0"

  # General ruby development
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"

  # Testing support
  spec.add_development_dependency "rspec", "~> 3.4"

  # Linting code and docs
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "yard"

  # Makes testing easy via `bundle exec guard`
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"

  # If you want to work on older builds of ruby
  spec.add_development_dependency "listen", "3.0.7"

  # This gives you the chance to run a REPL inside your tests
  # via:
  #
  #    require 'pry'
  #    binding.pry
  #
  # This will stop test execution and let you inspect the results
  spec.add_development_dependency "pry"
end
