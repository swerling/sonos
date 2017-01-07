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

    def do key, arg_string
      filter = arg_string

      regex = /#{arg_string.to_s.gsub(' ', '.*')}/i
      radio = get_radio.select{|i| i.title =~ regex }
      item = select_from_items(radio) # + lib + etc
      protocol = item.protocol_info
      if (protocol =~ /^x-rincon-mp3radio/)
        return play_mp3_radio_item(item)
      end
      puts "Don't know how to play #{item.inspect}"
    end

    def select_from_items(items)
      puts "selecting first item: #{items.first.title}"
      items.first
    end

    def get_radio
      @_radio ||= self.system.current_speaker.container_contents("R:0/0")
    end

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

      result = system.current_speaker.set_av_transport_uri(uri, meta)
      if result && result.http && result.http.code.eql?(200)
        system.current_speaker.play
        puts "Playing #{item.title}"
      end
    end

  end

end
end
