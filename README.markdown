ConfigModule
=============

Load important configuration files into their own modules!

[![Build Status](https://travis-ci.org/acook/config_module.png?branch=master)](https://travis-ci.org/acook/config_module)
[![Code Climate](https://codeclimate.com/github/acook/config_module.png)](https://codeclimate.com/github/acook/config_module)
[![Dependency Status](https://gemnasium.com/acook/config_module.png)](https://gemnasium.com/acook/config_module)

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

Now give it a try, any [valid](#caveats)
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

### Namespaces

You can also set the "namespace" you want to use, this is great for apps with different configurations per environment:

  ```ruby
  namespace ENV['my_environment']
  ```

  This will set the root of the configuration tree to whichever branch you specify, so you don't have to.

  Depending on your configuration file's structure, it might be useful to pull out a deeper subtree, in that case you can include multiple keys separated by commas, or even give it an array.

  Check out the [example section](#example) below to see how it's used.

### The `config` Method

 There's also a new method available in your module that points to the root of your configuration data:

  ```ruby
  def foo
    config.foo
  end
  ```

### Hash-like Access

You can access config options like a hash too, if you want:

  ```ruby
  MyConfig[:some_key].is_a? Hash #=> true
  ```

  This is useful mainly when you'd rather get a `nil` instead of raising an error for nonexistant keys:
  
  ```ruby
  MyConfig[:nonexistant_key] #=> nil
  MyConfig.nonexistant_key   #=> raises ConfigModule::ConfigOption::NotFoundError
  ```
  
  It'll also avoid any naming conflicts that might arise between methods defined on ConfigModule or ConfigOption and your key names. You can use it in concert with the above `config` method instead of `self` to enhance readability:
  
  ```ruby
  def bar
    config[:namespace]
  end
  ```


### Enumerable

  `ConfigOption` is the way ConfigModule packages up subtrees, and unlike `OpenStruct`, it is `Enumerable`:

  ```ruby
  MyConfig.some_key_with_subkeys.each do |subkey|
    puts subkey
  end
  ```

Example
-------

Given a YAML file `./config/example.yml':

```yaml
---
:example:
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
  namespace :example, Rails.env

  module_function

  def kanoodle
    'ka' + noodle
  end

  def all_keys
    config.map do |key, _|
      key
    end
  end
end
```

Then you can use it like this:

```ruby
ExampleConfig.foo       #=> 'bar'
ExampleConfig[:foo]     #=> 'bar'
ExampleConfig[:notakey] #=> nil
ExampleConfig.kanoodle  #=> 'kaboom!'
ExampleConfig.all_keys  #=> [:foo, :noodle]
```

Pretty nifty, huh?

Caveats
-------

- **Q:** You mention "valid key". What's a valid key?
- **A:** It's any object that you can call `.to_sym` on (same as `OpenStruct`)!

Who made this anyway?
---------------------

I'm glad you asked!

    Anthony M. Cook 2013

