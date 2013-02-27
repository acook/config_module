# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'config_module/version'

Gem::Specification.new do |gem|
  gem.name          = "config_module"
  gem.version       = ConfigModule::VERSION
  gem.authors       = ["Anthony Cook"]
  gem.email         = ["anthonymichaelcook@gmail.com"]
  gem.description   = %q{Wrap a configuration file in a module for easy use throughout your application. Inspired by Rails.}
  gem.summary       = %q{Load important configuration files into their own modules!}
  gem.homepage      = "http://github.com/acook/config_module"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-theme'
end
