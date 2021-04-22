class GamesController < ApplicationController
  before_action :set_game, only: %i[show play start]
  before_action :set_play, only: %i[show play]

  def index
    @games = Game
               .includes(:plays)
               .where(plays: {user: current_user})
               .order(created_at: :desc)
               .page(params[:page])
    @other_games = Game.where.not(status: :stopped).where.not(id: @games).limit(10)
  end

  def show
    @plays = @game.plays
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.plays.build(user: current_user)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def start
    redirect_to game_play_path(@game, current_user.plays.find_by!(game: @game))
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def set_play
    @play = Play.where(game: @game, user: current_user).first
  end

  def game_params
    params.require(:game).permit(:name, :length, user_ids: [], deck_ids: [])
  end
end
