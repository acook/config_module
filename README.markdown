ConfigModule
=============

Load important configuration files into their own modules!

Usage
-----

```ruby
require 'config_module'

module ExampleConfig
  extend ConfigModule

  config_file './config/example.yml'
  namespace Rails.env

  module_function

  def kanoodle
    'ka' + config.noodle
  end
end
```
