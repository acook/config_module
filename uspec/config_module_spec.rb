# frozen_string_literal: true

require_relative "spec_helper"
require_relative "example_config"

spec "modules extended with ConfigModule will load configurations" do
  ExampleConfig.foo == "bar"
end

spec "modules extended with ConfigModule have 'namespace' methods" do
  ExampleConfig.methods.include? :namespace
end

spec "config modules have [] methods" do
  ExampleConfig.respond_to? :[]
end

spec "config modules return correct data using []" do
  ExampleConfig[:foo] == "bar"
end

spec "when using [], return nil for nonexistant keys" do
  ExampleConfig[:nonexistant].nil?
end

spec "nested hash values are properly wrapped" do
  ExampleConfig.dictionary.class == ConfigModule::ConfigOption
end

spec "nested hash values stay wrapped on subsequent calls" do
  ExampleConfig.dictionary.class == ConfigModule::ConfigOption &&
    ExampleConfig.dictionary.class == ConfigModule::ConfigOption
end

spec "subkeys are accessible with methods" do
  ExampleConfig.dictionary.configuration == "An arrangement of elements in a particular form, figure, or combination."
end

spec "subkeys are accessible with methods on subsequent calls" do
  ExampleConfig.dictionary.configuration
  ExampleConfig.dictionary.configuration == "An arrangement of elements in a particular form, figure, or combination."
end

spec "subkeys work with .each" do
  text = []
  ExampleConfig.dictionary.each do |entry|
    text << entry.to_s
  end
  text.join == "[:configuration, \"An arrangement of elements in a particular form, figure, or combination.\"]"
end

spec "respond_to? works for top-level methods" do
  ExampleConfig.respond_to?(:dictionary) &&
    !ExampleConfig.respond_to?(:nonexistant)
end

spec "respond_to? works for subkey methods" do
  ExampleConfig.dictionary.respond_to?(:configuration) &&
    !ExampleConfig.dictionary.respond_to?(:nonexistant)
end

module FalseNil
  extend ConfigModule
  config_file "./config/false_nil.yml"
end

spec "false values are returned" do
  FalseNil.f == false
end

spec "nil values are preserved" do
  FalseNil.n.nil?
end

spec "missing keys raise exception when called as methods" do
  begin
    FalseNil.nonexistant
  rescue ConfigModule::ConfigOption::NotFoundError
    true
  end
end

module MultipleExample
  extend ConfigModule
  config_file "./config/example.yml"
  namespace :production, :dictionary
end

spec "multiple namespaces can be set" do
  MultipleExample.configuration == ExampleConfig.dictionary.configuration
end

module InvalidNamespaceExample
  extend ConfigModule
  config_file "./config/example.yml"
  namespace :jimmy, :pop, :ali
end

spec "incorrect namespaces raise informative errors" do
  begin
    InvalidNamespaceExample.whatever
  rescue ConfigModule::InvalidNamespaceError
    true
  end
end
