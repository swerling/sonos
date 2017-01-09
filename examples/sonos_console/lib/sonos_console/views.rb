module SonosConsole
module Views

  def self.content_item(item, highlight: nil)
    upnp_class =  item.upnp_class
    item_class = 'Unknown'
    item_class = 'Album' if upnp_class =~ /musicAlbum$/i
    item_class = 'Radio' if upnp_class =~ /audioBroadcast$/i
    item_class = 'Playlist' if upnp_class =~ /playlistContainer$/i

    artist = item.creator
    title = (artist.nil? || artist.empty?)? item.title : "#{artist} - '#{item.title}'"
    if highlight
      regex = /#{highlight}/i
      splits = title.split(regex)
      if !splits.empty?
        title = splits.join(highlight.bold.white)
      end
    end
    "#{item_class}: #{title}"
  end

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
    uri = np[:uri]
    if album.empty?
      "#{title} - #{info} - #{uri}"
    else
      "#{artist}: #{album} - #{title} #{info}"
    end
  end

  def self.speaker_state(speaker)
    state = speaker.get_player_state[:state].to_s.downcase
    return (state =~ /paused/)? 'paused' : state
  end

end
end
