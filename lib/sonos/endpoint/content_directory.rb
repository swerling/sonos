module Sonos::Endpoint::ContentDirectory

  class ContentItem
    attr_accessor :id,
                  :title,
                  :upnp_class,
                  :protocol_info,
                  :album_art_uri,
                  :creator,
                  :resource
    def initialize(args={}); args.each{|k,v| send("#{k}=", v)}; end
  end

  CONTENT_DIRECTORY_ENDPOINT = '/MediaServer/ContentDirectory/Control'
  CONTENT_DIRECTORY_XMLNS = 'urn:schemas-upnp-org:service:ContentDirectory:1'

  # Get the radio station listing ("My Radio Stations")
  def radio_stations
    container_contents "R:0/0"
  end

  def albums
    container_contents "A:ALBUM"
  end

  def queue
    container_contents "Q:0"
  end

  def playlists
    container_contents "A:PLAYLISTS"
  end

  def sonos_playlists
    container_contents "SQ:"
  end

  # Get the contents of a given content directory container
  def container_contents(container)
    name = 'Browse'
    action = "#{CONTENT_DIRECTORY_XMLNS}##{name}"
    starting_index = 0
    requested_count = 1_000_000
    requested_count = 1_000_000
    #message = %Q{<u:#{name} xmlns:u="#{CONTENT_DIRECTORY_XMLNS}"><ObjectID>#{container}</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>#{starting_index}</StartingIndex><RequestedCount>#{requested_count}</RequestedCount><SortCriteria></SortCriteria></u:Browse>}
    message = %Q{<u:#{name} xmlns:u="#{CONTENT_DIRECTORY_XMLNS}"><ObjectID>#{container}</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>*</Filter><StartingIndex>#{starting_index}</StartingIndex><RequestedCount>#{requested_count}</RequestedCount><SortCriteria></SortCriteria></u:Browse>}
    result = content_directory_client.call name, soap_action: action, message: message
    parse_items(result.body[:browse_response][:result])
  end

  private

  def content_directory_client
    @content_directory_client ||= Savon.client endpoint: "http://#{self.ip}:#{Sonos::PORT}#{CONTENT_DIRECTORY_ENDPOINT}", namespace: Sonos::NAMESPACE, log: Sonos.logging_enabled
  end

  def parse_items(string)
    doc = Nokogiri::XML(string)
    (doc.css('item') + doc.css('container')).map do |item|
      res = item.css('res').first
      ContentItem.new(
        id: item['id'],
        protocol_info: res['protocolInfo'],
        resource: res.text,
        creator: item.xpath('dc:creator').text,
        title: item.xpath('dc:title').text,
        album_art_uri: item.xpath('upnp:albumArtURI').text,
        upnp_class: item.xpath('upnp:class').text)
    end
#      result << {
#        queue_id: item['id'],
#        title: item.xpath('dc:title').inner_text,
#        artist: item.xpath('dc:creator').inner_text,
#        album: item.xpath('upnp:album').inner_text,
#        album_art: "http://#{self.ip}:#{Sonos::PORT}#{item.xpath('upnp:albumArtURI').inner_text}",
#        duration: res['duration'],
#        id: res.inner_text
#      }
  end
end
