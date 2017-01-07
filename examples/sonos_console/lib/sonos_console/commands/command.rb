module SonosConsole
module Commands

  class Command

    attr_reader :shortcut, :name, :help

    def initialize(opts={})
      @shortcut = opts.fetch(:shortcut)
      @name = opts.fetch(:name)
      @help = opts[:example]
    end

    def system
      SonosConsole::System.instance
    end

    def shortcut_description
      self.shortcut
    end

    # return whether string matches our shortcut
    def selected_by?(string)
      if shortcut.is_a?(Regexp)
        string =~ shortcut
      else
        string.eql?(shortcut)
      end
    end

    def do key, arg_string
      raise NotImplementedError.new("subclass responsibility")
    end

  end

end
end
