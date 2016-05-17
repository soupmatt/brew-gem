require 'aruba/rspec'

module BrewGemBin
  def brew_gem
    File.expand_path('../../../bin/brew-gem', __FILE__)
  end
end

module CleanEnv
  def run(*args)
    clean_env = Bundler.clean_env
    (ENV.keys - clean_env.keys).each {|k| delete_environment_variable k }
    # Also delete any RVM crud
    delete_environment_variable "RUBYOPT"
    delete_environment_variable "RUBYLIB"
    delete_environment_variable "GEM_PATH"
    delete_environment_variable "GEM_HOME"
    path = ENV['PATH'].split(/:/)
    # Remove .rvm/.rbenv stuff from PATH
    set_environment_variable "PATH", path.reject {|x| x =~ %r{/.(rvm|rbenv)/} }.join(":")
    super
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
