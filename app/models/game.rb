class Game < ApplicationRecord

  attr_accessor :moves

  # STATE_OPTIONS = %w(waiting running draw declared informed)

  # validates :state, :inclusion => { in: STATE_OPTIONS }

  before_create :game_state

  def game_state
    self.state = 'waiting'
  end

end
