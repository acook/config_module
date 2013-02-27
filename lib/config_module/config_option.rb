module ConfigModule
  class ConfigOption < OpenStruct
    def self.wrap data
      if data.is_a? Hash then
        ConfigOption.new data
      else
        data
      end
    end

    def method_missing name, *args, &block
      result = super

      if result || @table.include?(name) then
        self.class.wrap result
      else
        raise ConfigOption::NotFoundError.new name, self
      end
    end

    def new_ostruct_member name
      name = name.to_sym
      unless respond_to? name
        define_singleton_method(name) { self.class.wrap @table[name] }
        define_singleton_method("#{name}=") { |x| modifiable[name] = x }
      end
      name
    end

    class NotFoundError < ::ConfigModule::ConfigError
      def identifier; :key; end
    end
  end
end
