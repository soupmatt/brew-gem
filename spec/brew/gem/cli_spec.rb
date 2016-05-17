require 'spec_helper'

RSpec.describe Brew::Gem::CLI do
  context "#expand_formula" do
    subject(:formula) { described_class.expand_formula("foo-bar", "1.2.3") }

    it "generates valid Ruby" do
      IO.popen("ruby -c -", "r+") { |f| f.puts formula }
      expect($?).to be_success
    end

    it { is_expected.to match(/class GemFooBar < Formula/) }

    it { is_expected.to match(/version "1\.2\.3"/) }
  end

end
