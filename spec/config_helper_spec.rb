require_relative 'spec_helper'

helper = ConfigModule::ConfigHelper.new
helper.config_file = './config/example.yml'

spec 'method_missing_handler traces back to the caller' do
  begin
    helper.method_missing_handler :nonexistant, caller(1)
  rescue NoMethodError => error
    error.backtrace.include? "spec/config_helper_spec.rb:6:in `<main>'"
  end
end

