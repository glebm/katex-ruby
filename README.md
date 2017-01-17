# KaTeX for Ruby [![Build Status](https://travis-ci.org/glebm/katex-ruby.svg?branch=master)](https://travis-ci.org/glebm/katex-ruby) [![Test Coverage](https://codeclimate.com/github/glebm/katex-ruby/badges/coverage.svg)](https://codeclimate.com/github/glebm/katex-ruby/coverage) [![Code Climate](https://codeclimate.com/github/glebm/katex-ruby/badges/gpa.svg)](https://codeclimate.com/github/glebm/katex-ruby)

This rubygem enables you to render TeX math to HTML using [KaTeX].
It uses [ExecJS] under the hood.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'katex', '~> 0.1.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install katex

## Usage

Render some math:

```ruby
Katex.render 'c = \\pm\\sqrt{a^2 + b^2}'
#=> "<span class=\"katex\">..."
```

### Assets

For this rendered math to look nice, you will also need to include KaTeX CSS
into the webpage.

I recommend you use the CSS bundled with this gem, to ensure version
compatibility.

If you use Rails, the assets are registered automatically and you simply need
to `//= require katex` if you use CSS or `@import "katex"` if you use Sass.

You can also `//= require katex` in your JS to access the KaTeX renderer in the
browser.

If you don't use Rails, you can find the assets in the `vendor/assets`
directory of the gem (`File.join(Katex.gem_path, 'vendor', 'assets')`).

### Caching

If you cache the output of `Katex.render`, make sure to use the KaTeX
version in the cache key, as the output may change between versions.

You can get the KaTeX version bundled with this gem via:

```ruby
Katex::KATEX_VERSION
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/glebm/katex.

This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).


[KaTeX]: https://github.com/Khan/KaTeX
[ExecJS]: https://github.com/rails/execjs
