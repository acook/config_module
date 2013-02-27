require_relative 'spec_helper'

spec 'ConfigOptions are Enumerable' do
  hash = {a: 5}
  opt = ConfigModule::ConfigOption.new hash

  opt.map{|k,v| v} == [5]
end
