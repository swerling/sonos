require 'singleton'

module SonosConsole
  class System
    include Singleton

    attr_reader :system, :speakers
    attr_accessor :current_speaker

    def initialize

      # Sonos gem does some discovery here. Expect pause
      @system = Sonos::System.new

      @speakers = @system.speakers.sort_by(&:name)
      @current_speaker = @speakers.first
    end

  end
end
