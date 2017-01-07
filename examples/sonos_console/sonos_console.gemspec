($LOAD_PATH.unshift File.expand_path("../lib", __FILE__)).uniq!
require 'sonos_console/version.rb'

Gem::Specification.new do |gs|
  gs.name          = "sonos_conole"
  gs.version       = SonosConsole::VERSION
  gs.authors       = ["Steve Swerling"]
  gs.email         = ["swerlingbiz@gmail.com"]
  gs.summary       = "minimal shell for controlling sonos"
  gs.description   = gs.summary
  #gs.homepage      = "todo"
  gs.files         = Dir.glob("lib/**/*") +
                     Dir.glob("bin/**/*")
                     #Dir.glob("test/**/*")
  gs.executables   = gs.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #gs.test_files    = gs.files.grep(%r{^test/})
  gs.require_paths = ["lib"]

  gs.add_dependency 'colored' , "~> 1.0"
  #gs.add_dependency 'curses', "~> 1.0.0"
  #gs.add_dependency 'sonos', "~> 0.3"

  gs.add_development_dependency "rake", "~> 12"
  gs.add_development_dependency "pry"

end
