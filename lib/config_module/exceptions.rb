# frozen_string_literal: true

module ConfigModule
  # for when a config setting error occurs
  class ConfigError < NoMethodError
    def initialize name, object, details = nil
      @name, @object, @details = name, object, details
    end
    attr_reader :name, :object, :details

    def message
      "invalid #{identifier} `#{name}' for #{object_info}"
    end

    def object_info
      if object.is_a?(Class)
        object.name
      else
        "instance of `#{object.class} < #{object.class.superclass}'"
      end
    end
  end

  class InvalidNamespaceError < ConfigError
    def identifier; :namespace; end
  end

  # for when config_file path isn't found
  class ConfigFileNotFound < EOFError
    def initialize config_file
      @config_file = config_file
    end
    attr_reader :config_file

    def message
      "config_file `#{config_file}` not found."\
      "Make sure it exists in the location specified."
    end
  end

  # for when config_file was not set
  class ConfigFileNotSpecified < TypeError
    def initialize config_file
      @config_file = config_file
    end
    attr_reader :config_file

    def message
      "config_file location is #{config_file.inspect}."\
      "Set your config's location with the `config_file` method."
    end
  end
end
