# frozen_string_literal: true

require_relative "spec_helper"

def self.helper
  @helper ||= begin
    @helper = ConfigModule::ConfigHelper.new
    @helper.config_file = "./config/example.yml"
    @helper.namespaces = ["production"]
    @helper.config
    @helper
  end
end

table = helper.load_config.instance_variable_get(:@table)

spec "namespaces obtain subtrees of the full config" do
  table.keys == [:foo, :noodle, :dictionary]
end

spec "specifying a namespace forces #config to return that subtree the first time its called" do
  symbolized_keys_from_full_config = helper.raw_config["production"].keys.map(&:to_sym)
  symbolized_keys_from_full_config == table.keys
end

spec "nested namespaces are handled properly" do
  helper = ConfigModule::ConfigHelper.new
  helper.config_file = "./config/example.yml"
  helper.namespaces = %w[production dictionary]
  helper.config.has_key?("configuration") &&
    helper.config[:configuration] == helper.raw_config["production"]["dictionary"]["configuration"]
end

spec "misconfigured namespaces provide useful errors" do
  helper = ConfigModule::ConfigHelper.new
  helper.config_file = "./config/example.yml"
  helper.namespaces = ["nonexistant"]

  begin
    helper.config
  rescue ConfigModule::InvalidNamespaceError => error
    error.message.include?("nonexistant") || error.message
  end
end

spec "out of bounds namespaces are checked properly" do
  helper = ConfigModule::ConfigHelper.new
  helper.config_file = "./config/example.yml"
  helper.namespaces = %w[production foo bar]

  begin
    helper.config
  rescue ConfigModule::InvalidNamespaceError => error
    error.message.include?("bar") || error.message
  end
end

spec "invalid namespaces which are ruby objects display properly" do
  helper = ConfigModule::ConfigHelper.new
  helper.config_file = "./config/example.yml"
  helper.namespaces = [Array, Hash]

  begin
    helper.config
  rescue ConfigModule::InvalidNamespaceError => error
    error.message.include?("Array") || error.message
  end
end
