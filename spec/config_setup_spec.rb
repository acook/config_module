require_relative 'spec_helper'
require_relative 'example_config'

spec 'able to set options using setup' do
  c = ConfigModule.setup do
    method_name :new_name
    file_path :new_path
  end

  expected = {method_name: :new_name, file_path: :new_path}
  actual   = c.instance_variable_get(:@options)

  actual == expected || actual
end
