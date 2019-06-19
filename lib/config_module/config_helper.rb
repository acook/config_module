# frozen_string_literal: true

module ConfigModule
  class ConfigHelper
    attr_reader :raw_config
    attr_accessor :config_file
    attr_writer :namespaces

    def config
      @config ||= ConfigOption.wrap load_config
    end

    def method_missing_handler name, source, *args, &block
      ConfigOption.wrap config.send(name, *args, &block)
    rescue NoMethodError => error
      raise unless error.name == name

      raise(
        ConfigOption::NotFoundError.new(name, self, error),
        error.message, source
      )
    end

    def respond_to_missing_handler name, include_all
      config.send(:respond_to_missing?, name, include_all)
    end

    def field_lookup_handler name, _source, *_args, &_block
      config[name]
    end

    def load_config
      raise ConfigModule::ConfigFileNotSpecified, config_file unless config_file
      raise ConfigModule::ConfigFileNotFound, config_file unless File.exist? config_file

      yaml_load
      load_namespaces_from raw_config
    end

    def load_namespaces_from tree
      namespaces.inject(ConfigOption.wrap(tree)) do |subtree, ns|
        if ConfigOption === subtree && ns.respond_to?(:to_sym) && subtree.has_key?(ns)
          ConfigOption.wrap subtree[ns]
        else
          raise(
            InvalidNamespaceError.new(ns, subtree, caller),
            "No subkey with name: #{ns.inspect}", caller(6)
          )
        end
      end
    rescue TypeError
      raise(
        InvalidNamespaceError.new(namespaces.first, self, caller),
        "Namespace must be a string or symbol, instead it was: #{namespaces.first.class}", caller(6)
      )
    end

    def namespaces
      @namespaces ||= []
    end

  private

    def yaml_load
      @raw_config =
        if YAML::VERSION >= "3.0.2"
          YAML.load_file config_file, fallback: {}
        elsif YAML::VERSION >= "2.1.0"
          YAML.load_file config_file, {}
        else
          YAML.load_file(config_file) || {} # ambiguous with false or nil value
        end
    end
  end
end
