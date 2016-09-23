require_relative 'spec_helper'

Dir['*_spec.rb'].each do |filename|
  require File.absolute_path(filename)
end
