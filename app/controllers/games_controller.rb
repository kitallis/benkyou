class GamesController < ApplicationController
  before_action :set_game, only: %i[show play start]
  before_action :set_game_user, only: %i[show play]

  def index
    @games = Game.all
  end

  def show; end

  def play; end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.create_with_player!(current_user)
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def start
    @game.start!(for_player: current_user)
    redirect_to play_game_path
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def set_game_user
    @game_user = GameUser.where(game: @game, user: current_user).first
  end

  def game_params
    params.require(:game).permit(:name, :length)
  end
end
