module SonosConsole
module Commands

  class Proc < Command

    attr_accessor :action

    def do key
      action.call
    end

  end

end
end

