# POST /AlarmClock/Control HTTP/1.1
# SOAPACTION: "urn:schemas-upnp-org:service:AlarmClock:1#ListAlarms"

# Request
#<?xml version="1.0" encoding="UTF-8"?>
#<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
#    <s:Body>
#      <u:ListAlarms xmlns:u="urn:schemas-upnp-org:service:AlarmClock:1" />
#    </s:Body>
#</s:Envelope>

# Response
#<?xml version="1.0" encoding="UTF-8"?>
#<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
#  <s:Body>
#    <u:ListAlarmsResponse xmlns:u="urn:schemas-upnp-org:service:AlarmClock:1">
#      <CurrentAlarmList>&lt;Alarms&gt;&lt;Alarm ID="8" StartTime="19:21:00" Duration="02:00:00" Recurrence="ONCE" Enabled="0" RoomUUID="RINCON_000E583564A601400" ProgramURI="x-rincon-buzzer:0" ProgramMetaData="" PlayMode="SHUFFLE_NOREPEAT" Volume="25" IncludeLinkedZones="0"/&gt;&lt;/Alarms&gt;</CurrentAlarmList>
#      <CurrentAlarmListVersion>RINCON_000E583564A601400:26</CurrentAlarmListVersion>
#    </u:ListAlarmsResponse>
#  </s:Body>
#</s:Envelope>

module Sonos::Endpoint::Alarm
  ALARM_CLOCK_ENDPOINT = '/AlarmClock/Control'
  ALARM_CLOCK_XMLNS = 'urn:schemas-upnp-org:service:AlarmClock:1'

  # List the alarms that have been defined
  def list_alarms
    send_alarm_message('ListAlarms')
  end

  def create_alarm
    options = {:StartLocalTime => '13:19:00', :Duration => '02:00:00',
               :Recurrence => 'ONCE', :Enabled => 1, :RoomUUID => 'RINCON_000E583564A601400',
               :PlayMode => 'SHUFFLE_NOREPEAT', :Volume => 25, :IncludeLinkedZones => 0,
               :ProgramURI => 'x-rincon-buzzer:0', :ProgramMetaData => nil}

    part = convert_hash_to_xml(options)
    send_alarm_message('CreateAlarm', part)
  end

  def destroy_alarm(id)
    send_alarm_message('DestroyAlarm', "<ID>#{id}</ID>")
  end

  def update_alarm
    options = {:ID => 8, :StartLocalTime => '13:19:00', :Duration => '02:00:00',
               :Recurrence => 'ONCE', :Enabled => 1, :RoomUUID => 'RINCON_000E583564A601400',
               :PlayMode => 'SHUFFLE_NOREPEAT', :Volume => 25, :IncludeLinkedZones => 0,
               :ProgramURI => 'x-rincon-buzzer:0', :ProgramMetaData => nil}

    part = convert_hash_to_xml(options)
    send_alarm_message('UpdateAlarm', part)
  end

  private

  def alarm_client
    @alarm_client ||= Savon.client endpoint: "http://#{self.ip}:#{Sonos::PORT}#{ALARM_CLOCK_ENDPOINT}", namespace: Sonos::NAMESPACE
  end

  def send_alarm_message(name, part = '')
    action = "#{ALARM_CLOCK_XMLNS}##{name}"
    message = %Q{<u:#{name} xmlns:u="#{ALARM_CLOCK_XMLNS}">#{part}</u:#{name}>}
    alarm_client.call(name, soap_action: action, message: message)
  end

  def convert_hash_to_xml(options = {})
    updatePart = ''
    options.each do |optionKey, optionValue|
      updatePart += "<#{optionKey}>#{optionValue}</#{optionKey}>"
    end
    return updatePart
  end

end