# frozen_string_literal: true

require "ostruct"
require "yaml"

require_relative "config_module/version"
require_relative "config_module/exceptions"
require_relative "config_module/config_option"
require_relative "config_module/config_helper"

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

  # rubocop:disable Style/MethodMissing
  def method_missing name, *args, &block
    __config_module_helper.method_missing_handler name, caller(1), *args, &block
  end
  # rubocop:enable Style/MethodMissing

  def respond_to_missing? name, include_all
    __config_module_helper.respond_to_missing_handler(name, include_all) || super
  end
end
