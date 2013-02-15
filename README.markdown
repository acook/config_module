ConfigModule
=============

Load important configuration files into their own modules!

Usage (in 4 easy steps)
-----

1. Install the gem, preferably using [Bundler](http://gembundler.com/):

  ```ruby
  gem 'config_module'     # in your Gemfile
  ```

  ```bash
  bundle install          # on the command line
  ```

2. Tell Ruby that you want to use it:

  ```ruby
  require 'config_module'
  ```

3. Add the ConfigModule functionality to your module:

  ```ruby
  extend ConfigModule
  ```

4. Specify the name of your configuration file:

  ```ruby
  config_file './some_config.yml'
  ```

5. **(OPTIONAL)** You can also set the "namespace" you want to use, this is great for apps with multiple environments:

  ```ruby
  namespace ENV['my_environment']
  ```

Then you're set up, and you can add any other functionality, aliases, or derived values to your module like any other Ruby module.

See the below example for how it all fits together!

Example
-------

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
