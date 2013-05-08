module ConfigModule
  class ConfigOption < OpenStruct
    include Enumerable

    def self.wrap data
      if data.is_a? Hash then
        ConfigOption.new data
      else
        data
      end
    end

    def each
      return to_enum __method__ unless block_given?
      @table.each_pair{|p| yield p}
    end

    def [] name
      @table[name.to_sym]
    end

    def has_key? key
      @table.has_key? key
    end

    def method_missing name, *args, &block
      result = super

      if result || @table.has_key?(name) then
        self.class.wrap result
      else
        raise(
          ConfigOption::NotFoundError.new(name, self, caller),
          "Key not found: #{name}", caller(3)
        )
      end

    rescue NoMethodError => error
      raise(
        ConfigOption::NotFoundError.new(name, self, error),
        error.message, caller(3)
      )
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
