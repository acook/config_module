module Rails; def self.env; 'production'; end; end

Dir.chdir File.dirname(__FILE__)

require_relative '../config_module'
require_relative 'example_config'

require_relative 'mutest'
extend Mutest

spec 'modules extended with ConfigModule will load configurations' do
  ExampleConfig.foo == 'bar'
end

