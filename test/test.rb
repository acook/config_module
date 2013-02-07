require_relative 'mutest'
extend Mutest

require_relative '../config_module'
module Rails; def self.env; 'production'; end; end
require_relative 'example_config'

Dir.chdir File.dirname(__FILE__)

spec 'modules extended with ConfigModule will load configurations' do
  ExampleConfig.foo == 'bar'
end

spec 'modules extended with ConfigModule have "namespace" methods' do
  ExampleConfig.methods.include? :namespace
end

spec 'nested hash values are properly wrapped' do
  ExampleConfig.dictionary.class == ConfigOption
end
