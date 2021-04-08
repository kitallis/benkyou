class PlaysController < ApplicationController
  before_action :set_play, only: %i[show]
  before_action :set_game, only: %i[show]

  def show
    @questions = @play.questions
  end

  private

  def set_play
    @play = Play.find(params[:id])
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
