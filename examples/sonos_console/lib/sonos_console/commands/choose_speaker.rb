module SonosConsole
module Commands

  class ChooseSpeaker < Command

    include SonosConsole::Menu

    def do key
      speakers = sonos.speakers
      i = key.to_i
      if i.between?(1, speakers.size)
        sonos.current_speaker = speakers[i-1]
      else
        raise "Something wrong -- only integers should trigger this command"
      end
    end

    def shortcuts_description
      limit = sonos.speakers.size
      limit = 9 if limit > 9 # this UI cant handle double digit numbers, so limit of 9 speakers
      "1-#{limit}"
    end

    def help
      "press the number of the speaker you want to control"
    end
  end

end
end

