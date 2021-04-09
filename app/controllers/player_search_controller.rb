class PlayerSearchController < ApplicationController
  # before_action :set_game, only: %i[index]
  layout false

  def index
    # existing_players = @game.players
    players = User.where.not(id: current_user.id).search(params[:q])
    render json: players
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end