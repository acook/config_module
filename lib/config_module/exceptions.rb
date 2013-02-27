module ConfigModule
  class ConfigError < NoMethodError
    def initialize name, object
      @name, @object = name, object
      super "invalid #{identifier} `#{name}' for #{object_info}"
    end
    attr :name, :object

    def object_info
      if object.is_a?(Class) then
        object.name
      else
        "instance of `#{object.class} < #{object.class.superclass}'"
      end
    end
  end

  class InvalidNamespaceError < ConfigError
    def identifier; :namespace; end
  end
end
