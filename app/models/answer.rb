class Answer < ApplicationRecord
  belongs_to :card
  belongs_to :player

  validate :game_has_started?, on: :update

  scope :correct, -> { where(correct: true) }

  def correct?(card, attempt)
    deck = player.game.decks.find(card.deck)
    attempt == (deck.inverted? ? card.back : card.front)
  end

  def game_has_started?
    player.game.active?
  end
end
