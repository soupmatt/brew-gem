require 'erb'
require 'tempfile'

module Brew::Gem::CLI
  module_function

  COMMANDS = {
    "install"   => ("Install a brew gem, accepts an optional version argument\n" +
                    "            (e.g. brew gem install <name> [version])"),
    "upgrade"   => "Upgrade to the latest version of a brew gem",
    "uninstall" => "Uninstall a brew gem",
    "help"      => "This message"
  }

  def help_msg
    (["Please specify a gem name (e.g. brew gem command <name>)"] +
      COMMANDS.map {|name, desc| "  #{name} - #{desc}"}).join("\n")
  end

  def process_args(args)
    if !args[0] || args[0] == 'help'
      abort help_msg
    end

    command, name = args[0..1]

    gems = `gem list --remote "^#{name}$"`.lines

    unless gems.detect { |f| f =~ /^#{name} \(([^\s,]+).*\)/ }
      abort "Could not find a valid gem '#{name}'"
    end

    version = args[2] || $1

    [command, name, version]
  end

  def expand_template(name, version)
    klass         = 'Gem' + name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }.gsub('+', 'x')
    user_gemrc    = "#{ENV['HOME']}/.gemrc"
    template_file = File.expand_path('../template.rb.erb', __FILE__)
    template      = ERB.new(File.read(template_file))
    template.result(binding)
  end

  def with_temp_formula(name, version)
    filename = File.join Dir.tmpdir, "gem-#{name}.rb"

    open(filename, 'w') do |f|
      f.puts expand_template(name, version)
    end

    yield filename
  ensure
    File.unlink filename
  end

  def run(args = ARGV)
    command, name, version = process_args(args)

    with_temp_formula(name, version) do |filename|
      system "brew #{command} #{filename}"
    end
  end
end
