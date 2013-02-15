ConfigModule
=============

Load important configuration files into their own modules!

Usage Example
-------------

Given a YAML file `./config/example.yml':

```yaml
---
:production:
  :foo: bar
  :noodle: boom!
```

And you set up your module:

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

Then you can use it like this:

```ruby
ExampleConfig.foo       #=> 'bar'
ExampleConfig.kanoodle  #=> 'kaboom!'
```

Done!
