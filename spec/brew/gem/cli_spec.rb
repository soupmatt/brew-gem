require 'spec_helper'

RSpec.describe Brew::Gem::CLI do
  before { ENV['HOMEBREW_PREFIX'] = '/usr/local' }
  let(:cli) { described_class }

  context "#expand_formula" do
    subject(:formula) { cli.expand_formula("foo-bar", "1.2.3", false) }

    it "generates valid Ruby" do
      IO.popen("ruby -c -", "r+") { |f| f.puts formula }

      expect($?).to be_success
    end

    it { is_expected.to match(/class GemFooBar < Formula/) }

    it { is_expected.to match(/version "1\.2\.3"/) }
    it { is_expected.to match("BREWGEM_RUBYBINDIR = '/usr/bin'") }

    context "homebrew-ruby" do
      subject(:formula) { cli.expand_formula("foo-bar", "1.2.3", true) }
      it { is_expected.to match("BREWGEM_RUBYBINDIR = '/usr/local/bin'") }
    end
  end

  context "#run" do
    let(:gem)     { 'dummygem' }
    let(:version) { '1.0.1.0' }
    let(:formula) { 'temp-formula.rb' }
    let(:command) { '' }

    before do
      allow(cli).to receive(:exit)
      allow(cli).to receive(:system) {|x| command << x }
      allow(cli).to receive(:with_temp_formula).and_yield(formula)
      allow(cli).to receive(:fetch_version) {|n,v| v || version }
      allow(cli).to receive(:abort) {|msg| raise msg }
    end

    it 'runs brew on a formula file' do
      cli.run ['install', gem]
      expect(command.split).to eql(['brew', 'install', formula])
    end

    it 'accepts an optional requested version' do
      cli.run ['install', gem, '2.2.2']
      expect(command.split).to eql(['brew', 'install', formula])
      expect(cli).to have_received(:with_temp_formula).with(gem, '2.2.2', true)
    end

    it 'accepts a --homebrew-ruby flag' do
      cli.run ['install', gem, '--homebrew-ruby']
      expect(command.split).to eql(['brew', 'install', formula])
      expect(cli).to have_received(:with_temp_formula).with(gem, version, true)
    end

    it 'accepts a --system-ruby flag' do
      cli.run ['install', gem, '--system-ruby']
      expect(command.split).to eql(['brew', 'install', formula])
      expect(cli).to have_received(:with_temp_formula).with(gem, version, false)
    end

  end
end
