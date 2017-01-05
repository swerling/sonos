module SonosConsole

  class Shell

    attr_accessor :break, :commands

    def initialize
      @break = false
    end

    def system
      SonosConsole::System.instance
    end

    def go
      loop do
        begin
          print "#('h' for help) #{system.current_speaker.name}> "
          shortcut, args = Kernel.gets.to_s.split
          cmd1 = commands.detect{|c| c.shortcut.eql?(shortcut)}
          if cmd1
            cmd1.do(args)
          else
            puts "Unknown command, '#{shortcut}'"
            help
          end
          break if self.break
        rescue StandardError => x
          puts "#{x}, #{x.message}:\n\t#{x.backtrace.join("\n\t")}"
        end
      end
    end

    def help
      self.commands.sort_by(&:shortcut).each do |c|
        puts [c.shortcut,  c.name, c.example].compact.join(', ')
      end
    end

    def break!
      self.break = true
    end

  end

end
