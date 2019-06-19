# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "config_module/version"

Gem::Specification.new do |gem|
  gem.name = "config_module"
  gem.version = ConfigModule::VERSION
  gem.authors = ["Anthony M. Cook"]
  gem.email = ["github@anthonymcook.com"]
  gem.description = <<-DESC.chomp.gsub(/^ */, "")
    ConfigModule loads a YAML file into a module to make it easy to access and maintain your configurations.
    It provides helpers for namespaces (like environments), hash-like square-bracket access, helpful custom exceptions, and optimized repeat access.
  DESC
  gem.summary = "Load important configuration files into their own modules!"
  gem.homepage = "http://github.com/acook/config_module"
  gem.licenses = %w[MIT LGPL-3.0]

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "uspec", "~> 0.2.1"
end
