require 'spec_helper'

RSpec.describe Brew::Gem::CLI do
  before { ENV['HOMEBREW_PREFIX'] = '/usr/local' }

  context "#expand_formula" do
    subject(:formula) { described_class.expand_formula("foo-bar", "1.2.3", false) }

    it "generates valid Ruby" do
      IO.popen("ruby -c -", "r+") { |f| f.puts formula }

      expect($?).to be_success
    end

    it { is_expected.to match(/class GemFooBar < Formula/) }

    it { is_expected.to match(/version "1\.2\.3"/) }
    it { is_expected.to match("rubybindir = '/usr/bin'") }

    context "homebrew-ruby" do
      subject(:formula) { described_class.expand_formula("foo-bar", "1.2.3", true) }
      it { is_expected.to match("rubybindir = '/usr/local/bin'") }
    end
  end

end
