class PlaysController < ApplicationController
  before_action :set_play, only: %i[show]
  before_action :set_game, only: %i[show]

  def show
    @questions = @play.questions
  end

  private

  def set_play
    @play = Play.find_by!(id: params[:id], user: current_user)
  end

  def set_game
    @game = @play.game
  end
end
