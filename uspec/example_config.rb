# frozen_string_literal: true

module ExampleConfig
  extend ConfigModule

  config_file "./config/example.yml"
  namespace Rails.env

module_function

  def kanoodle
    "ka" + config.noodle
  end
end
