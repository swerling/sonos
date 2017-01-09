module SonosConsole
module Commands

  class PlayPause < Command

    attr_accessor :change

    def do key
      if sonos.current_speaker.playing?
        status "Pausing #{Views.now_playing(sonos.current_speaker)}"
        sonos.current_speaker.pause
      else
        status "Starting #{Views.now_playing(sonos.current_speaker)}"
        sonos.current_speaker.play
      end
    end

  end

end
end

