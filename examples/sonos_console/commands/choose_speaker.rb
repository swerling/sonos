module SonosConsole
module Commands

  class ChooseSpeaker < Command

    def speakers
      self.system.speakers
    end

    def do arg_string
      speakers.each_with_index do |s,i|
        puts "#{i+1}: #{s.name} #{s.get_player_state[:state]}"
      end
      puts "Enter 1-#{self.speakers.size}"
      choice = Kernel.gets.chomp.to_i - 1
      if choice < 0
        puts("unchanged")
      else
        s = speakers[choice]
        self.system.current_speaker = s
        puts "Choice: #{s.name}"
      end
    end

  end

end
end

