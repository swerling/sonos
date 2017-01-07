module SonosConsole
module Views

  def self.speakers(system, long: false)
    system.speakers.each_with_index.map do |s, i|
      "#{i+1}: #{speaker(s, long: long)}"
    end
  end

  def self.speaker(speaker, long: false)
    if long
      state = speaker.get_player_state[:state].to_s.downcase
      state = 'paused' if state =~ /paused/
      s = speaker.eql?(SonosConsole::System.instance.current_speaker)? '* ' : ''
      s << "#{speaker.name} is #{state}"
      if state !~ /stopped/i
        s << ": #{now_playing(speaker)}"
      end
      s
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
end
end
