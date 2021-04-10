class DeckSearchController < ApplicationController
  layout false

  def index
    decks = Deck.search(params[:q])
    render json: decks
  end
end
