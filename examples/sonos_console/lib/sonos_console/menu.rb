module SonosConsole
module Menu

  def choose(items, &block)
    items.each_with_index do |item,i|
      s = "#{i+1}: " + block.call(item)
      puts s
    end
    puts "Enter 1-#{items.size}"
    choice = Kernel.gets.chomp.to_i - 1
    if !choice.between?(0, items.size - 1)
      puts("(cancelled)")
      return nil
    else
      return items[choice]
    end
  end

end
end
