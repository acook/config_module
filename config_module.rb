require 'ostruct'
require 'yaml'

module ConfigModule
  def [] key
    config.send key
  end

  def config
    @config ||= load_config
  end

  def config_file file
    @config_file = file
  end

  def namespace name
    @namespace = name
  end

protected

  def wrap data
    if data.is_a? Hash then
      ConfigOption.new data
    else
      data
    end
  end

  def load_config
    file = YAML.load_file(@config_file)
    wrap @namespace ? (file[@namespace] || file[@namespace.to_sym]) : file
  end

  def method_missing name, *args, &block
    wrap config.send name, *args, &block
  end

  class ConfigOption < OpenStruct
  end
end
