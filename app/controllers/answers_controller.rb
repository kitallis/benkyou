class AnswersController < ApplicationController
  before_action :set_play, only: %i[show create]
  before_action :set_game, only: %i[show create]

  def create
    raise StandardError if @play.stopped?

    card_attempt_pairs.each do |(card_id, attempt)|
      @play.answers.create!(card_id: card_id, attempt: attempt)
    end

    redirect_to game_path(@game)
  end

  private

  def card_attempt_pairs
    params[:card_ids].zip(params[:answers])
  end

  def set_play
    @play = Play.find_by!(id: params[:play_id], user: current_user)
  end

  def set_game
    @game = @play.game
  end
end
