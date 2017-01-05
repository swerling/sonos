module SonosConsole
module Commands

  class Proc < Command

    attr_accessor :action

    def do arg_string
      action.call
    end

  end

end
end

