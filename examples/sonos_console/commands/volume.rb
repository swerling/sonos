module SonosConsole
module Commands

  class Select < Command

    def do arg_string
      filter = arg_string

      regex = arg_string.to_s.gsub(' ', '.*')
      radio = self.get_radio.map(&:title).grep(/#{arg_string}/i)
      puts "Radio: #{radio}"
    end

    def get_radio
      @_radio ||= self.system.current_speaker.container_contents("R:0/0")
    end

  end

end
end

