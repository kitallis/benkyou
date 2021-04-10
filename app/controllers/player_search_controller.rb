class PlayerSearchController < ApplicationController
  # before_action :set_game, only: %i[index]
  layout false

  def index
    # existing_players = @game.players
    players = User.where.not(id: current_user.id).search(search_term)
    render json: players
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def search_term
    params[:q].downcase
  end
end
