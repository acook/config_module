require 'ostruct'
require 'yaml'
require 'pry'

require_relative 'config_module/version'
require_relative 'config_module/exceptions'
require_relative 'config_module/config_option'

module ConfigModule
  def [] key
    config.send key
  end

  def config
    @config ||= ConfigOption.wrap load_config
  end

protected

  def config_file file
    @config_file = file
  end

  def namespace *name
    @namespace = Array name
  end

private

  def namespaced?
    !(@namespace.nil? || @namespace.empty?)
  end

  def load_config
    file = YAML.load_file(@config_file)

    if namespaced? then
      load_namespaces_from file
    else
      file
    end
  end

  def load_namespaces_from file
    @namespace.inject(file) do |inner, ns|
      if inner.respond_to? :[] then
        inner[ns.to_s] || inner[ns.to_sym]
      else
        raise(InvalidNamespaceError.new(ns, inner))
      end
    end
  end

  def method_missing name
    ConfigOption.wrap config.get name
  rescue ConfigOption::NotFoundError => error
    if error.name == name then
      raise ConfigOption::NotFoundError.new(name, self), caller(1)
    else
      raise
    end
  end
end
