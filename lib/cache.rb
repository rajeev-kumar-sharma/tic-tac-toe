require 'singleton'

module Cache
  class Storage
    include Singleton

    def initialize
      @users = { }
      @games = { }
    end
  
    attr_accessor :users, :games
  end
end