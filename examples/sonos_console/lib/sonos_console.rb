require 'colored'

require 'sonos'

load 'sonos_console/system.rb'
load 'sonos_console/shell.rb'
load 'sonos_console/menu.rb'
load 'sonos_console/views.rb'
load 'sonos_console/commands/command.rb'

Dir[ File.expand_path('sonos_console/commands/*.rb', File.dirname(__FILE__)) ].each do |fn|
  load fn
end

shell = SonosConsole::Shell.new

shell.commands = [
  [/\d/, 'choose speaker', nil, SonosConsole::Commands::ChooseSpeaker],
  ['d', 'debug', nil, SonosConsole::Commands::Debug ],
  ['q', 'quit', nil, proc{ exit(0) } ],
  ['z', 'pause', nil, proc { SonosConsole::System.instance.current_speaker.pause }],
  ['p', 'play', nil, proc { SonosConsole::System.instance.current_speaker.play }],
  ['r', 'reload', nil, proc{ shell.break!; puts 'reloading'; load __FILE__ } ],
  ['s', 'select music', nil, SonosConsole::Commands::Select],
  ['v', 'volume', "eg. 'v 10' increases volume 10, 'v -10' decreases by 10", SonosConsole::Commands::Volume],
].map do |shortcut, name, help, klz_or_proc|
    if klz_or_proc.is_a?(Proc)
      command = SonosConsole::Commands::Proc.new(shortcut: shortcut, name: name, help: help)
      command.action = klz_or_proc
      command
    else
      klz_or_proc.new(shortcut: shortcut, name: name, help: help)
    end
end

shell.go
