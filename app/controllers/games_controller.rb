class GamesController < ApplicationController
  before_action :check_player, only: [:create]
  before_action :set_game, only: [:show, :update]

  # GET /games/1
  def show
    # In-memory load
    games = Cache::Storage.instance.games
    game = games.empty? ? nil : games[@game[:id]]
    board = game ? game[:board] : { }

    render json: { game: @game, moves: board.moves }
  end

  # POST /games
  def create
    @game = Game.new(game_params)

    if @game.save
      # In-memory write
      Cache::Storage.instance.games[@game[:id]] = { player_1: @game.player_1, board: Board.new, state: 'waiting' }
      # END

      render json: @game, status: :created, location: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /games/1
  def update
    # In-memory load
    games = Cache::Storage.instance.games
    game = games.empty? ? nil : games[@game[:id]]
    
    users = Cache::Storage.instance.users
    user = game && users.empty? ? nil : ((users.select { |k, v| !v[:game] }).keys - [game[:player_1]]).sample
    # END

    if game && user
      @game[:player_2] = user
      @game[:state] = 'running'

      # In-memory update
      game[:player_2] = user
      game[:state] = 'running'

      users[@game[:player_1]][:game] = true
      users[user][:game] = true
      # END

      if @game.save
        render json: @game, status: :created, location: @game
      else
        render json: @game.errors, status: :unprocessable_entity
      end
    else
      render json: { errors: ['No other user is available to play'] }, status: :unprocessable_entity
    end
  end

  private
    def check_player
      @player = User.find(params[:player_1])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      params.require(:game).permit(:player_1)
    end
end
