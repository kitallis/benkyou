class DeckSearchController < ApplicationController
  layout false

  def index
    decks = Deck.search(search_term)
    render json: decks
  end

  private

  def search_term
    params[:q].downcase
  end
end
