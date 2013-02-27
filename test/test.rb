require_relative 'mutest'
extend Mutest

require_relative '../lib/config_module'
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
  ExampleConfig.dictionary.class == ConfigModule::ConfigOption
end

spec 'config modules have [] methods' do
  ExampleConfig[:dictionary].keys.include? :configuration
end

spec 'subkeys are accessible with methods' do
  ExampleConfig.dictionary.configuration == 'An arrangement of elements in a particular form, figure, or combination.'
end

module FalseNil
  extend ConfigModule
  config_file './config/false_nil.yml'
end

spec 'false values are returned' do
  FalseNil.f == false
end

spec 'nil values are preserved' do
  FalseNil.n == nil
end

spec 'missing keys raise exception when called as methods' do
  begin
    FalseNil.nonexistant
  rescue ConfigModule::ConfigOption::NotFound
    true
  end
end

module MultipleExample
  extend ConfigModule
  config_file './config/example.yml'
  namespace :production, :dictionary
end

spec 'multiple namespaces can be set' do
  MultipleExample.configuration == ExampleConfig.dictionary.configuration
end
