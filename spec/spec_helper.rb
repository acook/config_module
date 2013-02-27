require 'bundler/setup'
require 'uspec'

Dir.chdir File.dirname(__FILE__)

require_relative '../lib/config_module'

extend Uspec

module Rails; def self.env; 'production'; end; end
