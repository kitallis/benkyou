class PlaysController < ApplicationController
  before_action :set_play, only: %i[show]
  before_action :set_game, only: %i[show create]

  def show
    @questions = @play.questions
  end

  def create
    @play = @game.plays.new(user_id: params[:user_id])

    if @play.save
      redirect_to @game, notice: "Player was sucessfully added."
    else
      render @game, status: :unprocessable_entity
    end
  end

  private

  def set_play
    @play = Play.find_by!(id: params[:id], user: current_user)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
