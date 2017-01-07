module SonosConsole
module Commands

  class Debug < Command
    def do key
      puts '*' * 80
      puts '*'
      puts "$s is SonosConsole.sonos"
      puts '*'
      puts "control-d to exit pry"
      puts '*'
      puts '*' * 80
      $s = SonosConsole.sonos
      require 'pry'
      binding.pry
    end
  end
end
end

