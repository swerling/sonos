module SonosConsole
module Views

  def self.speakers(sonos, long: false)
    sonos.speakers.each_with_index.map do |s, i|
      "#{i+1}: #{speaker(s, long: long)}"
    end
  end

  def self.speaker(speaker, long: false)
    if long
      is_current = SonosConsole.sonos.current_speaker.eql?(speaker)
      state = speaker_state(speaker)
      s = "#{speaker.name} is #{state}"
      if state !~ /stopped/i
        s << ": #{now_playing(speaker)}"
      end

      (is_current)? s.bold.green : s.green
    else
      speaker.name
    end
  end

  def self.now_playing(speaker)
    np = speaker.now_playing
    title = np[:title]
    artist = np[:artist]
    album = np[:album]
    info = np[:info]
    "#{title} #{artist} #{album} #{info}"
  end

  def self.speaker_state(speaker)
    state = speaker.get_player_state[:state].to_s.downcase
    return (state =~ /paused/)? 'paused' : state
  end

end
end
