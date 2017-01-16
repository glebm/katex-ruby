# frozen_string_literal: true
require 'katex/version'
require 'katex/engine' if defined?(Rails)
require 'execjs'

# Provides a Ruby wrapper for KaTeX server-side rendering.
module Katex
  @load_context_mutex = Mutex.new
  @context = nil

  class << self
    def render(math)
      katex_context.call 'katex.renderToString', math
    end

    def katex_context
      @load_context_mutex.synchronize do
        @context ||= ExecJS.compile(File.read(katex_js_path))
      end
    end

    def katex_js_path
      File.expand_path File.join('vendor', 'assets', 'javascripts', 'katex.js'),
                       gem_path
    end

    def gem_path
      @gem_path ||=
        File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end
  end
end
