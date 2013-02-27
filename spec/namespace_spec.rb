require_relative 'spec_helper'

def self.helper
  if @helper then @helper
  else
    @helper = ConfigModule::ConfigHelper.new
    @helper.config_file = './config/example.yml'
    @helper.namespaces = 'production'
    @helper.config
    @helper
  end
end

spec 'namespaces obtain subtrees of the full config' do
  result = helper.load_namespaces_from helper.raw_config
  result == {"foo"=>"bar", "noodle"=>"boom!", "dictionary"=>{"configuration"=>"An arrangement of elements in a particular form, figure, or combination."}}
end

spec 'specifying a namespace forces #config to return that subtree the first time its called' do
  symbolized_keys_from_full_config = helper.raw_config['production'].keys.map(&:to_sym)
  keys_from_config_option_object = helper.config.instance_variable_get(:@table).keys

  symbolized_keys_from_full_config == keys_from_config_option_object
end
