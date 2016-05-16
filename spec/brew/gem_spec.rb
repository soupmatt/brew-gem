require 'spec_helper'

RSpec.describe Brew::Gem, type: :aruba  do
  subject(:aruba_cmd) { run_complete "#{brew_gem} #{command}" }

  let(:help_message) { Regexp.new Regexp.quote(Brew::Gem::CLI.help_msg.lines.first) }

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

end
