require 'ostruct'
require 'yaml'

require_relative 'config_module/version'
require_relative 'config_module/exceptions'
require_relative 'config_module/config_option'
require_relative 'config_module/config_helper'

module ConfigModule
  def [] key, *args
    __config_module_helper.field_lookup_handler key, caller(1), *args
  end

  def config
    __config_module_helper.config
  end

  def has_key? key
    __config_module_helper.config.has_key? key
  end

protected

  def config_file new_config_file
    __config_module_helper.config_file = new_config_file
  end

  def namespace *new_namespace
    __config_module_helper.namespaces = new_namespace.flatten
  end

private

  def __config_module_helper
    @__config_module_helper ||= ConfigHelper.new
  end

  def method_missing name, *args, &block
    __config_module_helper.method_missing_handler name, caller(1), *args
  end

  module_function

  def setup &block
    options = {
      method_name: 'config',
      file_path: './config/settings.yml',
    }

    setup_dsl = Class.new do
      def method_name new_name
        options[:method_name] = new_name
      end

      def file_path new_path
        options[:file_path] = new_path
      end

      def options
        @options ||= Hash.new
      end
    end

    if block_given? then
      options.merge! setup_dsl.new.tap{|dsl| dsl.instance_eval &block}.options
    end

    Module.new do
      @options = options
    end
  end
end
