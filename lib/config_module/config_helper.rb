module ConfigModule
  class ConfigHelper
    attr :raw_config
    attr_accessor :config_file, :namespaces

    def config
      @config ||= ConfigOption.wrap load_config
    end

    def method_missing_handler name, source
      config.send name
    rescue NoMethodError => error
      if error.name == name then
        raise # ConfigOption::NotFoundError.new(name, source)#, source
      else
        raise
      end
    end

    def load_config
      @raw_config = YAML.load_file config_file

      load_namespaces_from raw_config
    end

    def load_namespaces_from tree
      return tree unless namespaced?

      Array(namespaces).inject(ConfigOption.wrap tree) do |subtree, ns|
        raise(InvalidNamespaceError.new(ns, subtree)) unless subtree.respond_to? ns

        subtree.send ns
      end
    end

    def namespaced?
      !(namespaces.nil? || namespaces.empty?)
    end
  end
end
