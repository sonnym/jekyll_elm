# jekyll_elm

Compile Elm scripts and include them in a Jekyll site.

## Installation

1.  Add this line to your application's Gemfile `gem 'jekyll_elm'`.
2.  And then execute `bundle`.
3.  Add the following to your `_config.yml`: `gems: [jekyll_elm]`.
4.  Copy `elm-runtime.js` into `javascripts`.

This final step may eventually be streamlined.
See: https://github.com/elm-lang/Elm/issues/492

For the time being, you can find it in the following manner, assuming you
have `cabal` configured to install packages in your home directory:
`find ~/.cabal -name 'elm-runtime.js'`

## Usage

Simple create a new post/draft/page/whatever with the extension `.elm`. It will
be detected and compiled.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/jekyll_elm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
