require 'sonos_console/keys'

module SonosConsole

  class Shell

    include Keys

    protected

    attr_accessor :exception_count

    public

    attr_accessor :break, :commands

    def initialize
      @break = false
      @exception_count = 0
    end

    def sonos
      SonosConsole.sonos
    end

    def go
      loop do
        get_one
        break if self.break
      end
    end

    def get_one
      begin
        puts "\n" + Views.speakers(sonos, long: true).join("\n")
        puts "\nPress 'h' for help\n"
        print '> '
        #shortcut, args = Kernel.gets.to_s.split
        key = self.get_key
        cmd = commands.detect{|c| c.selected_by?(key) }
        if cmd
          print ": #{cmd.name}\n"
          cmd.do(key)
        elsif key =~/^\s*$/
          puts "Hey now, it's me, Hank!"
          # nop
        else
          help
        end
      rescue StandardError => x
        puts "#{x}, #{x.message}:\n\t#{x.backtrace.join("\n\t")}"
        self.exception_count = self.exception_count + 1
        if self.exception_count > 4
          puts "To many errors, exiting"
          self.break = true
        end
      end
    end



    def help
      self.commands.sort_by{|c| c.shortcut.to_s}.each do |c|
        puts "\t#{[c.shortcut_description,  c.name, c.help].compact.join(', ')}".blue
      end
    end

    def break!
      self.break = true
    end

  end

end
