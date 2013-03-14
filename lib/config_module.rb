require 'ostruct'
require 'yaml'
require 'pry'

require_relative 'config_module/version'
require_relative 'config_module/exceptions'
require_relative 'config_module/config_option'
require_relative 'config_module/config_helper'

module ConfigModule
  def [] key
    __config_module_helper.config.send key
  end

  def config
    __config_module_helper.config
  end

protected

  def config_file new_config_file
    __config_module_helper.config_file = new_config_file
  end

  def namespace *new_namespace
    __config_module_helper.namespaces = *new_namespace
  end

private

  def __config_module_helper
    @__config_module_helper ||= ConfigHelper.new
  end

  def method_missing name, *args, &block
    super unless args.empty?
    __config_module_helper.method_missing_handler name, caller(1)
  end
end
