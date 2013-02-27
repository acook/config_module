module ConfigModule
  class ConfigHelper
    attr :raw_config

    def config_file= new_config_file
      @config_file = new_config_file
    end

    def namespaces= new_namespaces
      @namespaces = Array new_namespaces
    end

    def namespaced?
      !(@namespaces.nil? || @namespaces.empty?)
    end

    def config
      @config ||= ConfigOption.wrap load_config
    end

    def load_config
      @raw_config = YAML.load_file(@config_file)

      if namespaced? then
        load_namespaces_from @raw_config
      else
        @raw_config
      end
    end

    def load_namespaces_from file
      @namespaces.inject(file) do |subtree, ns|
        raise(InvalidNamespaceError.new(ns, subtree)) unless subtree.respond_to? :[]

        subtree[ns.to_s] || subtree[ns.to_sym]
      end
    end

    def method_missing_handler name, source
      ConfigOption.wrap config.get name
    rescue ConfigOption::NotFoundError => error
      #if error.name == name then
        #raise ConfigOption::NotFoundError.new(name, self), source
      #else
        raise
      #end
    end
  end
end
