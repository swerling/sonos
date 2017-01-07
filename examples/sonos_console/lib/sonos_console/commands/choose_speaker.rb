module SonosConsole
module Commands

  class ChooseSpeaker < Command

    include SonosConsole::Menu

    def do key, args = nil
      speakers = self.system.speakers
      i = key.to_i
      if i.between?(1, speakers.size)
        self.system.current_speaker = speakers[i-1]
      else
        raise "Something wrong -- only integers should trigger this command"
      end
    end

    def shortcut_description
      "0-9"
    end

    def help
      "press the number of the speaker you want to control"
    end
  end

end
end

