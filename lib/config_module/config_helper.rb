module ConfigModule
  class ConfigHelper
    attr :raw_config
    attr_accessor :config_file, :namespaces

    def config
      @config ||= ConfigOption.wrap load_config
    end

    def method_missing_handler name, source, *args, &block
      ConfigOption.wrap config.send(name, *args, &block)
    rescue NoMethodError => error
      if error.name == name then
        raise(
          ConfigOption::NotFoundError.new(name, self, error),
          error.message, source
        )
      else
        raise
      end
    end

    def field_lookup_handler name, source, *args, &block
      config[name]
    end

    def load_config
      @raw_config = YAML.load_file config_file

      load_namespaces_from raw_config
    end

    def load_namespaces_from tree
      namespaces.inject(ConfigOption.wrap tree) do |subtree, ns|
        if ConfigOption === subtree && ns.respond_to?(:to_sym) && subtree.has_key?(ns)
          ConfigOption.wrap subtree[ns]
        else
          raise(
            InvalidNamespaceError.new(ns, subtree, caller),
            "No subkey with name: #{ns.inspect}", caller(6)
          )
        end
      end
    rescue TypeError => error
      raise(
        InvalidNamespaceError.new(namespaces.first, self, caller),
        "Namespace must be a string or symbol, instead it was: #{namespaces.first.class}", caller(6)
      )
    end

    def namespaces
      @namespaces ||= Array.new
    end
  end
end
