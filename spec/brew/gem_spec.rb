require 'spec_helper'

RSpec.describe Brew::Gem, type: :aruba  do
  subject(:aruba_cmd) { run_complete "#{brew_gem} #{command}" }

  let(:help_message) { Regexp.new Regexp.quote(Brew::Gem::CLI.help_msg.lines.first) }

  context "aruba environment" do
    it "doesn't contain any Bundler or RVM stuff" do
      cmd = run_complete "env"
      output = cmd.output
      expect(output).to_not match(/^BUNDLE_/)
      expect(output).to_not match(/^GEM_/)
      expect(output).to_not match(/^RUBY(OPT|LIB)/)
    end
  end

  context "help" do
    let(:command) { "help" }

    it { is_expected.to have_output(help_message) }

    it { is_expected.to be_successfully_executed }
  end

  context "no command" do
    let(:command) { "" }

    it { is_expected.to have_output(help_message) }

    it { is_expected.to_not be_successfully_executed }
  end

  context "unknown command" do
    let(:command) { "unknown" }

    it { is_expected.to have_output(/unknown command: #{command}/) }

    it { is_expected.to have_output(help_message) }

    it { is_expected.to_not be_successfully_executed }
  end

  context "install/uninstall" do #, announce_stderr: true, announce_stdout: true do
    let(:install_cmd)   { run_complete "#{brew_gem} install chronic" }
    let(:brew_cmd)      { run_complete "brew list gem-chronic" }
    let(:uninstall_cmd) { run_complete "#{brew_gem} uninstall chronic" }

    after do |example|
      if example.exception
        cmd = run "#{brew_gem} uninstall chronic"
        cmd.stop
      end
    end

    it "installs and uninstalls the gem" do
      expect(install_cmd).to   be_successfully_executed
      expect(brew_cmd).to      be_successfully_executed
      expect(uninstall_cmd).to be_successfully_executed
    end
  end
end
