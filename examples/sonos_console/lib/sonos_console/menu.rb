module SonosConsole
module Menu
  include Keys

  def choose(items, prompt: nil, return_bad_choice: false, &block)
    items.each_with_index do |item,i|
      s = "#{i+1}: " + block.call(item)
      puts s
    end
    if prompt
      puts prompt
    else
      puts "Enter 1-#{items.size}"
    end
    choice = self.get_key(echo: false)
    i = choice.to_i - 1
    if i.between?(0, items.size - 1)
      return items[i]
    else
      if return_bad_choice
        return choice
      else
        return nil
      end
    end
  end

end
end
