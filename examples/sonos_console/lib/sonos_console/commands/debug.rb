module SonosConsole
module Commands

  class Debug < Command
    def do key, arg_string
      puts '*' * 80
      puts '*'
      puts "$s is SonosConsole::System.instance"
      puts '*'
      puts "control-d to exit pry"
      puts '*'
      puts '*' * 80
      $s = SonosConsole::System.instance
      require 'pry'
      binding.pry
    end
  end
end
end

