# frozen_string_literal: true

require_relative "spec_helper"

hash = { a: { b: 5 } }
opt = ConfigModule::ConfigOption.new hash

spec "includes Enumerable (deprecated)" do
  ConfigModule::ConfigOption.include?(Enumerable)
end

spec "responds to #[]" do
  opt.respond_to? :[]
end

spec "#[] returns value associated with key" do
  opt[:a] == hash[:a]
end

spec "supports each" do
  x = []
  opt.each { |k, v| x << [k, v] } == opt && x == [[:a, { b: 5 }]]
end

spec "supports each_pair" do
  x = []
  opt.each_pair { |k, v| x << [k, v] } == opt && x == [[:a, { b: 5 }]]
end

spec "supports each_key" do
  x = []
  opt.each_key { |k| x << k } == opt && x == [:a]
end

spec "supports each_value" do
  x = []
  opt.each_value { |v| x << v } == opt && x == [{ b: 5 }]
end

spec "supports each as enumerator" do
  opt.each.class == Enumerator && opt.each.to_a == [[:a, { b: 5 }]]
end

spec "supports each_pair as enumerator" do
  opt.each_pair.class == Enumerator && opt.each_pair.to_a == [[:a, { b: 5 }]]
end

spec "supports each_key as enumerator" do
  opt.each_key.class == Enumerator && opt.each_key.to_a == [:a]
end

spec "supports each_value as enumerator" do
  opt.each_value.class == Enumerator && opt.each_value.to_a == [{ b: 5 }]
end

spec "can be frozen" do
  frozen = opt.dup.freeze
  frozen.frozen?
end

spec "when frozen, defines methods which return the right results" do
  frozen = opt.dup.freeze
  frozen.a.class == ConfigModule::ConfigOption
end

spec "when frozen, does not freeze nested options" do
  frozen = opt.dup.freeze
  !frozen.a.frozen?
end

spec "when frozen, nested options still work" do
  frozen = opt.dup.freeze
  frozen.a.b == 5
end

spec "identifies the presence of keys" do
  opt.has_key? :a
end

spec "identifies the presence of keys as strings" do
  opt.has_key? "a"
end

spec "identifies the lack of keys" do
  opt.has_key?("nonexistant") == false
end

spec "identifies the presence of nested keys" do
  opt.a.has_key? :b
end

spec "to_ary" do
  begin
    opt.to_ary
  rescue ConfigModule::ConfigOption::NotFoundError
    true
  end
end
