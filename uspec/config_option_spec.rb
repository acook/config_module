require_relative 'spec_helper'

hash = {a: {b: 5}}
opt = ConfigModule::ConfigOption.new hash

spec 'responds to #[]' do
  opt.respond_to? :[]
end

spec '#[] returns value associated with key' do
  opt[:a] == hash[:a]
end

spec 'ConfigOptions are Enumerable' do
  opt.map{|k,v| v[:b]} == [5]
end

spec 'identifies the presence of keys' do
  opt.has_key? :a
end

spec 'identifies the lack of keys' do
  opt.has_key?('nonexistant') == false
end

spec 'identifies the presence of nested keys' do
  opt.a.has_key? :b
end

spec 'to_ary' do
  begin
    opt.to_ary
  rescue NoMethodError => error
    error.class == ConfigModule::ConfigOption::NotFoundError
  end
end

