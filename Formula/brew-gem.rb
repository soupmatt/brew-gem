require 'formula'

class BrewGem < Formula
  url 'https://github.com/josh/brew-gem/tarball/v0.1.1'
  homepage 'https://github.com/josh/brew-gem'
  md5 '239de6c784e84f6ca1a37d38acc9c2cf'

  def install
    bin.install 'bin/brew-gem'
  end
end
