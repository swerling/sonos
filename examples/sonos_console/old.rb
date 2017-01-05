class SonosConsole

  attr_reader :speakers, :commands
  attr_accessor :break, :current_speaker

  Command = Struct.new(:shortcut, :name, :example, :action)

  def initialize
    @speakers = system.speakers.sort_by{|s| s.name }
    @current_speaker = @speakers.first
    @commands = [
      Command.new('c', 'choose speakers', nil, proc { self.choose }),
      Command.new('d', 'debug', nil, proc { self.debug }),
      Command.new('r', 'reload', nil, proc { self.reload }),
      Command.new('p', 'play', nil, proc { current_speaker.play }),
      Command.new('z', 'pause', nil, proc { current_speaker.pause }),
      Command.new('v', 'volume', 'increase volume 10: "v 10"',
                  proc {|i| current_speaker.volume += i.to_i}),
      Command.new('q', 'quit', '', proc { exit(0) }),
    ]
  end

  def system
    SonosConsole::System.instance
  end

  def go
    self.break = false
    loop do
      print "#('h' for help) #{current_speaker.name}> "
      shortcut, args = Kernel.gets.to_s.split
      cmd1 = commands.detect{|c| c.shortcut.eql?(shortcut)}
      if cmd1
        cmd1.action.call(args)
      else
        help
      end
      break if self.break
    end

  end

  def debug
    require 'pry'
    binding.pry
  end

  def reload
    self.break = true
    load __FILE__
    load 'sonos'
    SonosConsole.new.go
  end

  def choose
    self.speakers.each_with_index do |s,i|
      puts "#{i+1}: #{s.name} #{s.get_player_state[:state]}"
    end
    puts "Enter 1-#{self.speakers.size}"
    choice = Kernel.gets.chomp.to_i - 1
    if choice < 0
      return puts("unchanged")
    else
      self.current_speaker = self.speakers[choice]
      puts "Choice: #{self.current_speaker.name}"
    end
  end

  def help
    self.commands.sort_by(&:shortcut).each do |c|
      puts [c.shortcut,  c.name, c.example].compact.join(', ')
    end
  end

end

#loop { SonosConsole.new.go }

