class GameDeck < ApplicationRecord
  belongs_to :game
  belongs_to :deck

  def cards
    deck.cards
  end

  def inverted?
    inverted
  end
end

