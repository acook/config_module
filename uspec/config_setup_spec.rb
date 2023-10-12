# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'example_config'

spec 'able to set options using setup' do
  c = ConfigModule.setup do
    method_name :new_name
    path 'new_path'
  end

  expected = {method_name: :new_name, path: 'new_path'}
  actual   = c.instance_variable_get(:@options)

  actual == expected || actual
end

spec 'setup method returns a module' do
  c = ConfigModule.setup
  c.class == Module
end


spec 'setup module can extend for full effect' do
  m = Module.new
  c = ConfigModule.setup do
    path 'config/example.yml'
  end
  m.extend c

  m.is_a? ConfigModule
end
