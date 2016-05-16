require 'erb'
require 'tempfile'

module Brew::Gem::CLI
  HELP_MSG = <<-STR
Please specify a gem name (e.g. brew gem command <name>)
  install - Install a brew gem, accepts an optional version argument (e.g. brew gem install <name> <version>)
  upgrade - Upgrade to the latest version of a brew gem
  uninstall - Uninstall a brew gem
STR

  def self.run(args = ARGV)
    if !args[0] || args[0] == 'help'
      abort HELP_MSG
    end

    command = args[0]
    name = args[1]
    gems = `gem list --remote "^#{name}$"`.lines

    unless gems.detect { |f| f =~ /^#{name} \(([^\s,]+).*\)/ }
      abort "Could not find a valid gem '#{name}'"
    end

    version = args[2] || $1

    klass         = 'Gem' + name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }.gsub('+', 'x')
    user_gemrc    = "#{ENV['HOME']}/.gemrc"
    template_file = File.expand_path('../template.rb.erb', __FILE__)
    template      = ERB.new(File.read(template_file))
    filename      = File.join Dir.tmpdir, "gem-#{name}.rb"

    begin
      open(filename, 'w') do |f|
        f.puts template.result(binding)
      end

      system "brew #{command} #{filename}"
    ensure
      File.unlink filename
    end
  end
end
