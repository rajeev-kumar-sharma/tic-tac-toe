class Board
  
  attr_accessor :grid, :moves, :turn, :count

  def initialize
    @grid = Array.new(3) { Array.new(3) }
    @moves = []
    @turn = 1
    @count = 0
  end
end
