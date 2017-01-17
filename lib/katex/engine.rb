# frozen_string_literal: true
module Katex
  module Rails
    # Registers KaTeX fonts, stylesheets, and javascripts with Rails.
    class Engine < ::Rails::Engine
      initializer 'katex.assets' do |app|
        %w(fonts javascripts).each do |sub|
          app.config.assets.paths << root.join('vendor', 'assets', sub).to_s
        end
        # Create sprockets versions of katex CSS that use asset-path for
        # referencing fonts.
        # One file is a Sass partial and the other one is .css.erb.
        app.config.assets.paths << root.join(
          'vendor', 'assets', 'sprockets', 'stylesheets'
        ).to_s
      end
    end
  end
end
