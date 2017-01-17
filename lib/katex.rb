# frozen_string_literal: true
require 'katex/version'
require 'katex/engine' if defined?(Rails)
require 'execjs'

# Provides a Ruby wrapper for KaTeX server-side rendering.
module Katex
  @load_context_mutex = Mutex.new
  @context = nil

  class << self
    # Renders the given math expression to HTML via katex.renderToString.
    #
    # @param math [String] The math (Latex) expression
    # @param display_mode [Boolean] Whether to render in display mode.
    # @param throw_on_error [Boolean] Whether to raise on error. If false,
    #   renders the error message instead.
    # @param render_options [Hash] Additional options for katex.renderToString.
    #   See https://github.com/Khan/KaTeX#rendering-options.
    # @return [String] HTML. If strings respond to html_safe, the result will be
    #   HTML-safe.
    def render(math, display_mode: false, throw_on_error: false,
               **render_options)
      result = katex_context.call(
        'katex.renderToString',
        math,
        displayMode: display_mode,
        throwOnError: throw_on_error,
        **render_options
      )
      result = result.html_safe if result.respond_to?(:html_safe)
      result
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
