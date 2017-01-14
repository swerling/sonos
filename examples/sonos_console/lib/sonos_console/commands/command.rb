module SonosConsole
module Commands

  class Command

    attr_reader :shortcuts, :name, :help

    def initialize(opts={})
      @shortcuts = opts.fetch(:shortcuts)
      @name = opts.fetch(:name)
      @help = opts[:example]
    end

    def sonos
      SonosConsole.sonos
    end

    def shortcuts_description
      self.shortcuts
    end

    # return whether string matches one of our shortcuts
    def selected_by?(string)
      hit = shortcuts.detect do |shortcut|
        if shortcut.is_a?(Regexp)
          string =~ shortcut
        else
          string.eql?(shortcut)
        end
      end
      !!hit
    end

    def do key, arg_string
      raise NotImplementedError.new("subclass responsibility")
    end

    def status(message)
      print "#{pad}#{message}#{clear}"
    end

    def clear
      ' ' * 30 + "\r"
    end

    def pad
      "\r" + ' ' * 3
    end

  end

end
end
