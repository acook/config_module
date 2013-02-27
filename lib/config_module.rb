require_relative 'config_module/version'
require 'ostruct'
require 'yaml'

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
      @namespace.inject(file) do |file, ns|
        file.include?(ns) && file[ns] || file.include?(ns.to_sym) && file[ns.to_sym]
      end
    else
      file
    end
  end

  def method_missing name
    ConfigOption.wrap config.get name
  rescue NoMethodError => error
    if error.name == name then
      raise NoMethodError, "undefined method `#{name}' for #{self}", caller(1)
    else
      raise
    end
  end

  class ConfigOption < OpenStruct
    def self.wrap data
      if data.is_a? Hash then
        ConfigOption.new data
      else
        data
      end
    end

    def get name
      if @table.include? name then
        self.class.wrap @table[name]
      else
        raise ConfigOption::NotFound
      end
    end

    class NotFound < RangeError; end
  end
end
