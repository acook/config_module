require_relative 'spec_helper'

spec 'responds to #[]' do
  ConfigModule::ConfigOption.new.respond_to? :[]
end

spec '#[] returns value associated with key' do
  opt = ConfigModule::ConfigOption.new key: 'value'
  opt[:key] == 'value'
end
