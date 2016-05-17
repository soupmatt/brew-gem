require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  # Specify RSPECOPTS=... on the rake command line to set extra RSpec flags
  t.rspec_opts = ENV['RSPECOPTS'] if ENV['RSPECOPTS']
end

task :default => :spec
