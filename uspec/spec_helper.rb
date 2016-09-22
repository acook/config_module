require 'bundler/setup'
require 'uspec'

if ENV['CI'] == 'true' then
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
  CodeClimate::TestReporter.configure do |config|
    config.git_dir = `git rev-parse --show-toplevel`.strip
  end
end

Dir.chdir File.dirname(__FILE__)

require_relative '../lib/config_module'

extend Uspec

module Rails; def self.env; 'production'; end; end
