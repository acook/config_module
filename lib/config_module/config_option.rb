module ConfigModule
  class ConfigOption < OpenStruct
    def self.wrap data
      if data.is_a? Hash then
        ConfigOption.new data
      else
        data
      end
    end

    def get name
      if @table.include? name then
        self.class.wrap @table[name]
      #elsif @table.include? name.to_s then
      #  self.class.wrap @table[name.to_s]
      else
        raise ConfigOption::NotFoundError.new name, self
      end
    end

    class NotFoundError < ::ConfigModule::ConfigError
      def identifier; :key; end
    end
  end
end
