ConfigModule
=============

Load important configuration files into their own modules!

Installation
------------

Install the [gem](http://rubygems.org/gems/config_module), preferably using [Bundler](http://gembundler.com/):

  ```ruby
  gem 'config_module'     # in your Gemfile
  ```

  ```bash
  bundle install          # on the command line
  ```

You may need to tell Ruby that you want to use it (depending how you're using Bundler):

  ```ruby
  require 'config_module' # in your file
  ```

Setup
-----

You only need to add two lines inside any module definition to make it a ConfigModule.

1. Add the ConfigModule functionality to your module:

  ```ruby
  extend ConfigModule
  ```

2. Specify the name of your configuration file:

  ```ruby
  config_file './some_config.yml'
  ```

Done! 

You're set up, and you can add any other functionality, aliases, or derived values to your module
like any other Ruby module.

Usage
-----

Now give it a try, any [valid](https://github.com/acook/config_module/edit/master/README.markdown#caveats) 
key in your configuration file will now be a method:

```ruby
SomeConfig.my_key
```

You can even chain them! Try it:

```ruby
SomeConfig.my_key.my_subkey
```

How cool is that?

Extras
------

In addition to the basics, ConfigModule also supplies a couple of helpers you might find useful.

1. You can also set the "namespace" you want to use, this is great for apps with multiple environments:

  ```ruby
  namespace ENV['my_environment']
  ```

  This will set the root of the tree to whichever branch you specify, so you don't have to.
  
2. There's also a new method available in your module that points directly to the raw configuration data:
   
  ```ruby
  config
  ```
  
  Don't overwrite this method!

3. You can still access raw data from outside the module too, if you want:
  
  ```ruby
  MyConfig[:some_key].is_a? Hash #=> true
  ```

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

Pretty nifty, huh?

Caveats
-------

- **Q:** You mention "valid key". What's a valid key? 
- **A:** It's any object that you can call `.to_sym` on!

Who made this anyway?
---------------------

I'm glad you asked!

    Anthony M. Cook 2013
    
