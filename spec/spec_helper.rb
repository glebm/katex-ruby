# frozen_string_literal: true
if ENV['COVERAGE'] && !%w(rbx jruby).include?(RUBY_ENGINE)
  require 'simplecov'
  SimpleCov.command_name 'RSpec'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'katex'
