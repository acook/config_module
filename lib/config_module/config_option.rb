# frozen_string_literal: true

module ConfigModule
  class ConfigOption < OpenStruct
    include Enumerable

    def self.wrap data
      if data.is_a? Hash
        new data
      else
        data
      end
    end

    def each_pair
      return to_enum(__method__) { @table.size } unless block_given?
      @table.each_pair { |pair| yield pair }
      self
    end
    alias each each_pair

    def each_key
      return to_enum(__method__) { @table.size } unless block_given?
      @table.each_key { |key| yield key }
      self
    end

    def each_value
      return to_enum(__method__) { @table.size } unless block_given?
      @table.each_value { |value| yield value }
      self
    end

    unless public_instance_method :[]
      def [] name
        @table[name.to_sym]
      end
    end

    def has_key? key
      @table.has_key? key.to_sym
    end
    alias key? has_key?

    def method_missing name, *args, &block
      result = super

      if result || @table.has_key?(name)
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

    def respond_to_missing? name, include_all
      @table.has_key?(name) || super
    end
    private :respond_to_missing?

    if private_instance_methods.include? :new_ostruct_member!
      # :reek:TooManyStatements { max_statements: 10 }
      def new_ostruct_member! name
        name = name.to_sym
        unless singleton_class.method_defined? name
          define_singleton_method(name) { self.class.wrap @table[name] }
          define_singleton_method("#{name}=") { |val| modifiable[name] = val }
        end
        name
      end
      private :new_ostruct_member!
      alias new_ostruct_member new_ostruct_member! # :nodoc:
      protected :new_ostruct_member
    elsif instance_methods.include? :new_ostruct_member
      # :reek:TooManyStatements { max_statements: 10 }
      def new_ostruct_member name
        name = name.to_sym
        unless respond_to? name
          define_singleton_method(name) { self.class.wrap @table[name] }
          define_singleton_method("#{name}=") { |val| modifiable[name] = val }
        end
        name
      end
      protected :new_ostruct_member
    end

    class NotFoundError < ::ConfigModule::ConfigError
      def identifier; :key; end
    end
  end
end
