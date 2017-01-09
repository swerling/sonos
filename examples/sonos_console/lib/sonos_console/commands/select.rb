# wireshark for playing a radio station:
#meta = "&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot;
#    xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot;
#    xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot;
#    xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;
#    &lt;item id=&quot;R:0/0/0&quot; parentID=&quot;R:0/0&quot; restricted=&quot;true&quot;&gt;
#        &lt;dc:title&gt;#{item.title}&lt;/dc:title&gt;
#        &lt;upnp:class&gt;object.item.audioItem.audioBroadcast&lt;/upnp:class&gt;
#        &lt;desc id=&quot;cdudn&quot; nameSpace=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot;&gt;
#            SA_RINCON65031_
#        &lt;/desc&gt;
#    &lt;/item&gt;
#&lt;/DIDL-Lite&gt;"
module SonosConsole
module Commands

  class Select < Command
    include Keys
    include Menu

    attr_accessor :filtered_items, :filter

    def do key
      h = <<-XXX
Type some chars of the radio station you want to hear.

Only the first 9 will be shown.

When you see the one you want, press the number to play it.
XXX
      puts h.cyan

      self.filter = ''
      loop do
        items = (radio_stations + albums + sonos_playlists).select{|i|
          Views.content_item(i) =~ /#{self.filter}/i
        }
        if items.size.eql?(0)
          puts "No matches for '#{filter}'".upcase
          self.shrink_filter
        else
          puts "Showing first 9 of #{items.size}"
          prompt =  "Current filter is '#{filter}'. Change filter or enter number from list above > "
          choice = choose(items[0..8],
                    prompt: prompt,
                    return_bad_choice: true) { |item|
                      Views.content_item(item, highlight: self.filter)
                    }
          if choice.is_a?(String)
            if %w(backspace del).include?(choice)
              self.shrink_filter
            elsif %w(enter).include?(choice)
              break
            else
              self.filter << choice
            end
          else
            selected(choice)
            break
          end
        end
      end
    end

    def selected(item)
      protocol = item.protocol_info
      if (protocol =~ /^x-rincon-mp3radio/)
        puts "Play mp3 radio station: #{item.title}"
        sonos.current_speaker.play_mp3_radio_item_or_album(item)
      elsif (protocol =~ /^x-rincon-playlist/)
        puts "Play playlist or album: #{item.title}"
        sonos.current_speaker.play_mp3_radio_item_or_album(item)
      elsif (item.upnp_class.eql?('object.container.playlistContainer'))
        return play_playlist_container(item)
      else
        puts "Don't know how to play #{item.inspect}"
      end
    end

    # play a whole playlist
    def play_playlist_container(item)
      puts "todo: play playlist"
    end


    def shrink_filter
      if self.filter.size > 0
        self.filter = self.filter[0..-2]
      end
    end

    def radio_stations
      @_rstats ||= sonos.current_speaker.radio_stations
    end

    def albums
      @_albums ||= sonos.current_speaker.albums
    end

    def sonos_playlists
      @_sq ||= sonos.current_speaker.sonos_playlists
    end

  end

end
end
