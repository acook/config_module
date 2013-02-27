require_relative 'spec_helper'

require_relative '../lib/config_module'
require_relative 'example_config'

Dir.chdir File.dirname(__FILE__)

spec 'modules extended with ConfigModule will load configurations' do
  ExampleConfig.foo == 'bar'
end

spec 'modules extended with ConfigModule have "namespace" methods' do
  ExampleConfig.methods.include? :namespace
end

spec 'config modules have [] methods' do
  ExampleConfig.respond_to? :[]
end

spec 'nested hash values are properly wrapped' do
  ExampleConfig.dictionary.class == ConfigModule::ConfigOption
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
  rescue ConfigModule::ConfigOption::NotFoundError
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

module InvalidNamespaceExample
  extend ConfigModule
  config_file './config/example.yml'
  namespace :jimmy, :pop, :ali
end

spec 'incorrect namespaces raise informative errors' do
  begin
    InvalidNamespaceExample.whatever
  rescue => error
    error.class == ConfigModule::InvalidNamespaceError
  end
end
