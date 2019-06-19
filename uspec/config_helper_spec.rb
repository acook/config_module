# frozen_string_literal: true

require_relative "spec_helper"

helper = ConfigModule::ConfigHelper.new
helper.config_file = "./config/example.yml"

spec "method_missing_handler traces back to the caller" do
  begin
    helper.method_missing_handler :nonexistant, caller(1)
  rescue NoMethodError => error
    error.backtrace.to_s.include?("spec/config_helper_spec.rb:8:in") || error.backtrace
  end
end

spec "is helpful when the config_file is not set" do
  begin
    configless_helper = ConfigModule::ConfigHelper.new
    configless_helper.load_config
  rescue ConfigModule::ConfigFileNotSpecified => error
    error.message.include?("config_file") || error
  end
end

spec "is helpful when the config_file is missing" do
  begin
    missing_helper = ConfigModule::ConfigHelper.new
    missing_helper.config_file = "god"
    missing_helper.load_config
  rescue ConfigModule::ConfigFileNotFound => error
    error.message.include?("config_file") || error
  end
end
