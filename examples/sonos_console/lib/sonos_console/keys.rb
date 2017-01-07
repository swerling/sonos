module SonosConsole
module Keys

  def get_keys(echo: true, current: '', &block)
    key = get_key(echo: echo)
    current << key
    if block.call(key, current)
      get_keys(echo: echo, current: current, &block)
    end
  end

  def get_key(echo: true)
    begin
      system("stty raw -echo")
      chars = STDIN.getc
      if chars.eql?("\e")
        chars << STDIN.getc
        chars << STDIN.getc
      end
      return 'up' if chars.eql?("\e[A")
      return 'down' if chars.eql?("\e[B")
      return 'right' if chars.eql?("\e[C")
      return 'left' if chars.eql?("\e[D")
      return 'backspace' if chars.eql?("\u007F")
      return 'del' if chars.eql?("\e[3")
      return 'enter' if chars.eql?("\r")
      return 'enter' if chars.eql?("\n")

      if echo && chars =~ /^[0-9a-zA-Z]+$/
        print(chars)
      end
      chars
      #c = STDIN.getc
      #c = STDIN.getc
      #print(c) if echo
      #c
    ensure
      system("stty -raw echo")
    end
  end


#  require 'curses'
#  include  Curses
#  def get_key(echo: true)
#    begin
#      #init_screen
#      #cbreak
#      noecho
#      stdscr.keypad = true
#
#      #refresh
#      ch = getch
#      #addch ?\n
#
#      case ch
#      when KEY_UP
#        return :arrow_up
#      else
#        #print(chars) if echo
#        #addstr "%s\n" % ch
#        addstr(ch) if echo
#      end
#
#      #refresh
#      return ch
#    ensure
#      #close_screen
#    end
#  end


end
end
