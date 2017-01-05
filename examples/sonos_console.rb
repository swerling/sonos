$: << File.expand_path('.', File.dirname(__FILE__))

load 'sonos_console/system.rb'
load 'sonos_console/shell.rb'
load 'sonos_console/commands/command.rb'
Dir[ File.expand_path('sonos_console/commands/*.rb', File.dirname(__FILE__)) ].each do |fn|
  load fn
end

shell = SonosConsole::Shell.new

shell.commands = [
  ['c', 'choose-speaker', nil, SonosConsole::Commands::ChooseSpeaker],
  ['d', 'debug', nil, SonosConsole::Commands::Debug ],
  ['q', 'quit', nil, proc{ exit(0) } ],
  ['z', 'pause', nil, proc { SonosConsole::System.instance.current_speaker.pause }],
  ['p', 'play', nil, proc { SonosConsole::System.instance.current_speaker.play }],
  ['r', 'reload', nil, proc{ shell.break!; puts 'reloading'; load __FILE__ } ],
  ['s', 'select music', nil, SonosConsole::Commands::Select],
  ['v', 'volume', "eg. 'v 10' increases volume 10, 'v -10' decreases by 10", SonosConsole::Commands::Volume],
].map do |shortcut, name, example, klz_or_proc|
    if klz_or_proc.is_a?(Proc)
      command = SonosConsole::Commands::Proc.new(shortcut: shortcut, name: name, example: example)
      command.action = klz_or_proc
      command
    else
      klz_or_proc.new(shortcut: shortcut, name: name, example: example)
    end
end
shell.go
#      @commands = [
#        Command.new('c', 'choose speakers', nil, proc { self.choose }),
#        Command.new('d', 'debug', nil, proc { self.debug }),
#        Command.new('r', 'reload', nil, proc { self.reload }),
#        Command.new('p', 'play', nil, proc { current_speaker.play }),
#        Command.new('z', 'pause', nil, proc { current_speaker.pause }),
#        Command.new('v', 'volume', 'increase volume 10: "v 10"',
#                    proc {|i| current_speaker.volume += i.to_i}),
#        Command.new('q', 'quit', '', proc { exit(0) }),
#      ]
