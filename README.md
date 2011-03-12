brew-gem -- install gems as homebrew formulas
=============================================

`brew gem` allows you to install any rubygem as a homebrew formula.

It works by generating a stub formula for homebrew, which looks something like this:

    class Ronn <Formula
      def initialize(*args)
        @name = "ronn"
        @version = "0.7.3"
        super
      end

      def install
        system "gem", "install", name, "--version", version, "--install-dir", prefix
      end
    end

This formula installs and unpacks all the dependencies under the Cellar path. So the package is completely self contained.

Install
-------

    brew install https://github.com/josh/brew-gem/raw/master/Formula/brew-gem.rb

Usage
-----

    brew gem heroku

Philosophy
----------

This is **not** for installing development libraries, but for standalone binary tools that you want system wide.
