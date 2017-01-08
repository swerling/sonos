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

Only the first 5 will be shown.

When you see the one you want, press the number to play it.
XXX
     puts h.cyan


      self.filter = ''
      loop do
        #items = radio_stations.select{|i| i.title =~ /#{self.filter}/i }
        items = []
        items = items + albums.select{|i|
          Views.content_item(i) =~ /#{self.filter}/i
        }
        if items.size.eql?(0)
          puts "No matches for '#{filter}'".upcase
          self.shrink_filter
        elsif items.size.eql?(1)
          selected(items.first)
          break
        else
          puts "Showing first 5 of #{items.size}"
          prompt =  "Current filter is '#{filter}'. Change filter or enter number from list above > "
          choice = choose(items[0..4],
                    prompt: prompt,
                    return_bad_choice: true) { |item|
                      Views.content_item(item, highlight: self.filter)
                    }
          if choice.is_a?(String)
            if %w(backspace del).include?(choice)
              self.shrink_filter
            elsif %w(q enter).include?(choice)
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
        return play_mp3_radio_item(item)
      elsif (protocol =~ /^x-rincon-playlist/)
        return play_playlist_item(item)
      end
      puts "Don't know how to play #{item.inspect}"
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

    def play_playlist_item(item)
      #puts "Playing #{item.title}"
      #puts "Todo: play playlist item"
      play_mp3_radio_item(item) # this works for albums at least
    end

    # TODO: move this into a_v_transport!
    def play_mp3_radio_item(item)
      puts "Play mp3 radio station: #{item.title}"
      tunein_service = 'SA_RINCON65031_' # what is this?
      meta = <<-XXX
      <DIDL-Lite xmlns:dc="http://purl.org/dc/elements/1.1/"
          xmlns:upnp="urn:schemas-upnp-org:metadata-1-0/upnp/"
          xmlns:r="urn:schemas-rinconnetworks-com:metadata-1-0/"
          xmlns="urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/">
          <item id="R:0/0/0" parentID="R:0/0" restricted="true">
              <dc:title>#{item.title}</dc:title>
              <upnp:class>#{item.upnp_class}</upnp:class>
              <desc id="cdudn" nameSpace="urn:schemas-rinconnetworks-com:metadata-1-0/">
                  #{tunein_service}
              </desc>
          </item>
      </DIDL-Lite>
      XXX
      meta = meta.gsub('<','&lt;').gsub('>','&gt;').strip
      uri = item.resource.gsub('&', '&amp;')

      result = sonos.current_speaker.set_av_transport_uri(uri, meta)
      if result && result.http && result.http.code.eql?(200)
        sonos.current_speaker.play
        puts "Playing #{item.title}"
      end
    end

  end

end
end
