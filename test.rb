module Rails; def self.env; 'production'; end; end

require './config_module'
require './example_config'

module Mutest
  def spec description
    return puts("#{yellow('pending:')} #{description}") unless block_given?

    print description

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

    def colorize boolean
      if boolean == true then
        green boolean
      elsif boolean == false then
        red boolean
      elsif boolean.is_a? Exception then
        red("error (exception):") + boolean.message + "\n\n" + white(error.backtrace)
      else
        red("error (unknown result):") + boolean.to_s
      end
    end
  end

private

  include Color
end

include Mutest

spec 'modules extended with ConfigModule will load configurations' do
  ExampleConfig.foo == 'bar'
end

