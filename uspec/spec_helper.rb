# frozen_string_literal: true

require "bundler/setup"
require "uspec"
Bundler.require :default, :test

if ENV["CI"] == "true"
  require "simplecov"
  SimpleCov.start
end

Dir.chdir File.dirname(__FILE__)

require_relative "../lib/config_module"

extend Uspec

module Rails; def self.env; "production"; end; end
