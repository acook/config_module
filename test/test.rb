module Rails; def self.env; 'production'; end; end

Dir.chdir File.dirname(__FILE__)

require_relative '../config_module'
require_relative 'example_config'

module Mutest
  def spec description
    return puts("#{yellow('pending:')} #{description}") unless block_given?

    print '-- ', description

    begin
      result = yield
    rescue => result
    end

    print ': ', colorize(result), "\n"
  end

  module Color
    def red text=nil
      "\e[31;1m#{text}#{normal if text}"
    end

    def green text=nil
      "\e[32;1m#{text}#{normal if text}"
    end

    def yellow text=nil
      "\e[33;1m#{text}#{normal if text}"
    end

    def white text=nil
      "\e[37;1m#{text}#{normal if text}"
    end

    def normal text=nil
      "\e[0m#{text}"
    end

    def colorize result
      if result == true then
        green result
      elsif result == false then
        red result
      elsif result.is_a? Exception then
        red("error (exception)") + vspace + hspace + result.message + vspace + white(trace result)
      else
        red("error (unknown result)") + vspace + hspace + result.to_s + vspace
      end
    end

    def trace error
      error.backtrace.inject(String.new) do |text, line|
        text << hspace + line + "\n"
      end
    end

    def hspace
      '    '
    end

    def vspace
      "\n\n"
    end
  end

private

  include Color
end

extend Mutest

spec 'modules extended with ConfigModule will load configurations' do
  ExampleConfig.foo == 'bar'
end

