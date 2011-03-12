require 'formula'

class BrewGem < Formula
  url 'https://github.com/josh/brew-gem/tarball/v0.1.1'
  homepage 'https://github.com/josh/brew-gem'
  md5 '73359fae1694b9ca84469c9a6960ae37'

  def install
    bin.install 'bin/brew-gem'
  end
end
