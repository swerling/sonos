begin
  require 'sonos_console'
  require File.expand_path('./sonos_console.rb', File.dirname(__FILE__))
rescue LoadError => x
  # We're probably doing dev. Try running via bundler
  require "bundler/setup"
  require 'sonos_console'
  require 'pry'
  #require File.expand_path('./sonos_console.rb', File.dirname(__FILE__))
end
