
module SonosConsole
module Commands

  class Volume < Command
    include Keys

    attr_accessor :change

    def do key
      puts <<-XXX
      Lowercase 'v' or DOWN arrow to lower volume
      Uppercase 'V' or UP arrow to raise volume
      Press Enter to return to main menu
      XXX

      self.change = 0

      if !sonos.current_speaker.playing?
        status "Current speaker is NOT playing, will turn on"
        turn_on = true
      else
        print_change
        turn_on = false
      end

      get_keys do |key, string|
        if ["q", "enter"].include?(key)
          status ''
          false
        else
          if turn_on
            sonos.current_speaker.play
            turn_on = false
          end
          if ['v', 'down', 'left'].include?(key)
            Thread.new{sonos.current_speaker.volume -= 1}
            self.change -= 1
          elsif ['V', 'up', 'right'].include?(key)
            Thread.new{sonos.current_speaker.volume += 1}
            self.change += 1
          else
            status "Press 'v', 'V', arrow keys, or Enter"
          end
          print_change
          true
        end
      end
    end

    def print_change
      if self.change < 0
        status "Volume lowered #{change}"
      elsif self.change.eql?(0)
        status "Volume unchanged"
      else
        status "Volume raised #{change}"
      end
    end

  end

end
end

