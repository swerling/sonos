module SonosConsole
module Commands

  class Command

    attr_reader :shortcut, :name, :example

    def initialize(opts={})
      @shortcut = opts.fetch(:shortcut)
      @name = opts.fetch(:name)
      @example = opts[:example]
    end

    def system
      SonosConsole::System.instance
    end

    def do arg_string
      raise NotImplementedError.new("subclass responsibility")
    end

  end

end
end
