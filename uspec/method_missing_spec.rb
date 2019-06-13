# frozen_string_literal: true

require_relative "spec_helper"
require_relative "example_config"

spec "method missing must handle multiple arguments gracefully" do
  begin
    ExampleConfig.nonexistant :foo, :bar
  rescue NoMethodError => error
    error.name == :nonexistant
  end
end
