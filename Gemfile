# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in config_module.gemspec
gemspec

if ENV["CI"] == "true"
  group :test do
    gem "simplecov"
    gem "codeclimate-test-reporter", "~> 1.0.0"
  end
else
  group :development do
    gem "travis"

    if RUBY_VERSION.to_f < 2.2
      byebug_version = "~> 9.0.6"
    elsif RUBY_VERSION.to_f < 2.3
      byebug_version = "~> 10.0.2"
    elsif RUBY_VERSION.to_f < 2.4
      byebug_version = "< 12"
    end
    gem "byebug", byebug_version

    gem "pry"
    gem "pry-doc"
    gem "pry-theme"
    gem "pry-rescue"
    gem "pry-byebug"
    gem "pry-coolline"
  end
end
