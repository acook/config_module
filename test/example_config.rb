module ExampleConfig
  extend ConfigModule

  config_file './config/example.yml'
  namespace Rails.env

  def kanoodle
    'ka' + config.noodle
  end
end