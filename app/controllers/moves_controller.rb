class MovesController < ApplicationController
  before_action :check_game, only: [:create]
  before_action :check_player, only: [:create]

  # POST /move
  def create
    if allowed?
      if @game[:state] == 'declared'
        render json: { success: true, done: true }
      else
        render json: { success: true, done: false }
      end
    else
      render json: { error: 'Invalid move' }, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def move_params
      params.require(:move).permit(:game_id, :user_id, :x, :y)
    end

    def check_game
      @game = Game.find(params[:game_id])
    end

    def check_player
      @player = User.find(params[:user_id])
    end

    # Rule Engine: Should be moved to a service
    def allowed?
      return false unless @game[:state] == 'running'

      game = Cache::Storage.instance.games[params[:game_id]]
      board = game ? game[:board] : nil

      return false unless (params[:x] >= 1 && params[:x] <= 3 && params[:y] >= 1 && params[:y] <= 3)

      if board.turn == 1
        return false unless game[:player_1] == params[:user_id]
      end

      if board.turn == 2
        return false unless game[:player_2] == params[:user_id]
      end

      if board && board.count < 10 && !board.grid[params[:x] - 1][params[:y] - 1]
        board.grid[params[:x] - 1][params[:y] - 1] = board.turn

        # In-memory 
        move = Move.new
        move.x = params[:x]
        move.y = params[:y]
        move.player = params[:user_id]
        board.moves << move
        board.count += 1

        if winner?(board.grid, board.turn)
          @game[:state] = 'declared'
          @game[:winner] = params[:user_id]
          @player[:won_count] += 1

          @game.save
          @player.save
        elsif board.count == 9
          @game[:state] = 'declared'
          @game[:draw] = true
          @player[:draw_count] += 1

          @game.save
          @player.save
        end

        board.turn = board.turn == 1 ? 2 : 1
        # END
      else
        return false
      end

      true
    end

    # Rule Engine: Should be moved to a service
    def winner?(grid, turn)
      winner = false

      # row
      for i in 0..2 do
        if grid[i][0] == turn && grid[i][1] == turn && grid[i][2] == turn
          winner = true
        end
      end

      # column
      for i in 0..2 do
        if grid[0][i] == turn && grid[1][i] == turn && grid[2][i] == turn
          winner = true
        end
      end

      # diagonal
      if grid[0][0] == turn && grid[1][1] == turn && grid[2][2] == turn
        winner = true
      end

      # diagonal
      if grid[0][2] == turn && grid[1][1] == turn && grid[2][0] == turn
        winner = true
      end

      return winner
    end
end
