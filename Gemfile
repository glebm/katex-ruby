# frozen_string_literal: true
source 'https://rubygems.org'

# Specify your gem's dependencies in katex.gemspec
gemspec

if ENV['TRAVIS']
  group :test do
    # CodeClimate coverage reporting.
    gem 'codeclimate-test-reporter', require: false
  end
end
