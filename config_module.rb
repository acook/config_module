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

  def load_config
    file = OpenStruct.new YAML.load_file(@config_file)
    @namespace ? file[@namespace] : file
  end

  def method_missing name, *args, &block
    config.send name, *args, &block
  end
end