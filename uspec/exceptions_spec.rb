# frozen_string_literal: true

require_relative "spec_helper"

spec "display appropriate error when the object is a class" do
  error = ConfigModule::InvalidNamespaceError.new :foo, Array
  error.message.include? "Array"
end
