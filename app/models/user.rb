class User < ApplicationRecord
  validates :email, uniqueness: true

  before_create :user_defaults
  
  def user_defaults
    self.online = false
    self.won_count = 0
    self.lost_count = 0
    self.draw_count = 0
  end
end
