class GameDeck < ApplicationRecord
  belongs_to :game
  belongs_to :deck

  delegate :cards, to: :deck
end
