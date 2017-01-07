
module SonosConsole
module Commands

  class Volume < Command

    def do key, arg_string
      self.system.current_speaker.volume += arg_string.to_i
    end

  end

end
end

