source 'https://rubygems.org'

# Specify your gem's dependencies in config_module.gemspec
gemspec

if ENV['CI'] == 'true' then
  group :test do
    gem 'simplecov'
    gem 'codeclimate-test-reporter', '~> 1.0.0'
  end
else
  group :development do
    gem 'travis'

    gem 'pry'
    gem 'pry-doc'
    gem 'pry-theme'
    gem 'pry-rescue'
    gem 'pry-byebug'
    gem 'pry-coolline'
    gem 'pry-stack_explorer'
  end
end
