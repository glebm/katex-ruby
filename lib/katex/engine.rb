# frozen_string_literal: true
module Katex
  module Rails
    # Registers KaTeX fonts, stylesheets, and javascripts with Rails.
    class Engine < ::Rails::Engine
      initializer 'katex.assets' do |app|
        %w(fonts javascripts).each do |sub|
          app.config.assets.paths << root.join('vendor', 'assets', sub).to_s
        end
        # Registers an sprockets version of the katex CSS that is a Sass file
        # that uses asset-path for referencing the fonts.
        app.config.assets.paths << root.join(
          'vendor', 'assets', 'sprockets', 'stylesheets'
        ).to_s
      end
    end
  end
end
