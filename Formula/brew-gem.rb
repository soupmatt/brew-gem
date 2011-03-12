require 'formula'

class BrewGem < Formula
  url 'https://github.com/josh/brew-gem/tarball/v0.1.0'
  homepage 'https://github.com/josh/brew-gem'
  md5 'c75aad7263040deacf1aa3f2d009c56a'

  def install
    bin.install 'bin/brew-gem'
  end
end
