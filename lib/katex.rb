# frozen_string_literal: true
require 'katex/version'
require 'katex/engine' if defined?(Rails)
require 'execjs'
require 'erb'

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
    #   renders the error message instead (even in case of ParseError, unlike
    #   the native katex).
    # @param error_color [String] Error text CSS color.
    # @param render_options [Hash] Additional options for katex.renderToString.
    #   See https://github.com/Khan/KaTeX#rendering-options.
    # @return [String] HTML. If strings respond to html_safe, the result will be
    #   HTML-safe.
    # @note This method is thread-safe as long as your ExecJS runtime is
    #   thread-safe. MiniRacer is the recommended runtime.
    def render(math, display_mode: false, throw_on_error: true,
               error_color: '#cc0000', macros: {}, **render_options)
      begin
        result = katex_context.call(
            'katex.renderToString',
            math,
            displayMode: display_mode,
            throwOnError: throw_on_error,
            errorColor: error_color,
            macros: macros,
            **render_options
        )
      rescue ExecJS::ProgramError => e
        raise e if throw_on_error
        result = <<~HTML
          <span class='katex'>
            <span class='katex-html'>
              <span style='color: #{error_color}'>
                #{ERB::Util.h e.message.sub(/^ParseError: /, '')}
              </span>
            </span>
          </span>
        HTML
      end

      result = result.html_safe if result.respond_to?(:html_safe)
      result
    end

    def katex_context
      @load_context_mutex.synchronize do
        @context ||= ExecJS.compile(File.read(katex_js_path))
      end
    end

    def katex_js_path
      File.expand_path File.join('vendor', 'katex', 'javascripts', 'katex.js'),
                       gem_path
    end

    def gem_path
      @gem_path ||=
        File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end
  end
end
