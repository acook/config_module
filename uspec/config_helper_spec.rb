# frozen_string_literal: true

require_relative "spec_helper"

helper = ConfigModule::ConfigHelper.new
helper.config_file = "./config/example.yml"

spec "method_missing_handler traces back to the caller" do
  begin
    helper.method_missing_handler :nonexistant, caller(1)
  rescue NoMethodError => error
    error.backtrace.to_s.include? "spec/config_helper_spec.rb:8:in"
  end
end
