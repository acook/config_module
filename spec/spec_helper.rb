require 'bundler/setup'
require 'uspec'

extend Uspec

module Rails; def self.env; 'production'; end; end
