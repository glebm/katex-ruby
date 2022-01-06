# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Update KaTeX from GitHub releases'
task :update, :version do |_task, args| # rubocop:disable Metrics/BlockLength
  require 'fileutils'
  require 'open-uri'

  # Download KaTeX
  version = args[:version]
  unless version
    warn 'Specify KaTeX version, e.g. rake update[v0.7.0]'
    exit 64
  end
  dl_path = File.join('tmp', 'katex-dl', version)
  FileUtils.mkdir_p(dl_path)
  archive_path = File.join(dl_path, 'katex.tar.gz')
  unless File.exist?(archive_path)
    url = 'https://github.com/KaTeX/KaTeX/releases/download/' \
          "#{version}/katex.tar.gz"
    IO.copy_stream(URI.open(url), archive_path) # rubocop:disable Security/Open
  end
  katex_path = File.join(File.dirname(archive_path), 'katex')
  unless File.directory?(katex_path)
    system 'tar', 'xf', archive_path, '-C', File.dirname(archive_path)
  end

  # Copy assets
  assets_path = File.join('vendor', 'katex')
  FileUtils.rm_rf assets_path
  FileUtils.mkdir_p assets_path
  FileUtils.cp_r File.join(katex_path, 'fonts'), assets_path
  if File.directory? File.join(katex_path, 'images')
    FileUtils.cp_r File.join(katex_path, 'images'), assets_path
  end
  FileUtils.mkdir_p File.join(assets_path, 'javascripts')
  FileUtils.cp File.join(katex_path, 'katex.min.js'),
               File.join(assets_path, 'javascripts', 'katex.js')
  FileUtils.mkdir_p File.join(assets_path, 'stylesheets')
  FileUtils.cp File.join(katex_path, 'katex.min.css'),
               File.join(assets_path, 'stylesheets', 'katex.css')

  # Create sprockets versions of katex CSS that use asset-path for referencing
  # fonts. One is a Sass version and the other one is .css.erb.
  sprockets_css_path = File.join(assets_path, 'sprockets', 'stylesheets')
  FileUtils.mkdir_p sprockets_css_path
  katex_css = File.read(File.join(katex_path, 'katex.css'))
  asset_url_regex = %r{url\(['"]?(?:fonts|images)/([^'")]*)['")]*}
  File.write(File.join(sprockets_css_path, '_katex.scss'),
             katex_css.gsub(asset_url_regex, "url(asset-path('\\1'))"))
  File.write(File.join(sprockets_css_path, 'katex.css.erb'),
             katex_css.gsub(asset_url_regex, "url(<%= asset_path('\\1') %>)"))

  # Update KATEX_VERSION in version.rb
  File.write('lib/katex/version.rb',
             File.read('lib/katex/version.rb')
                 .gsub(/KATEX_VERSION = '.*?'/, "KATEX_VERSION = '#{version}'"))
end

task default: :spec
