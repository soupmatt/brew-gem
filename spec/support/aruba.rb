require 'aruba/rspec'

module BrewGemBin
  def brew_gem
    File.expand_path('../../../bin/brew-gem', __FILE__)
  end
end

module CleanEnv
  def run(*args)
    Bundler.with_clean_env { super }
  end
end

module ArubaHelpers
  def run_complete(*args)
    cmd = run(*args)
    cmd.stop
    expect(cmd).to have_finished_in_time
    cmd
  end
end

RSpec.configure do |config|
  config.include CleanEnv
  config.include BrewGemBin
  config.include ArubaHelpers
end
