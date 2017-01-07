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
          puts "\n\t" + Views.speakers(system, long: true).join("\n\t") + "\n\n"
          print "#('h' for help) #{system.current_speaker.name}> "
          shortcut, args = Kernel.gets.to_s.split
          cmd1 = commands.detect{|c| c.selected_by?(shortcut) }
          if cmd1
            cmd1.do(shortcut, args)
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
      self.commands.sort_by{|c| c.shortcut.to_s}.each do |c|
        puts [c.shortcut_description,  c.name, c.help].compact.join(', ')
      end
    end

    def break!
      self.break = true
    end

  end

end
