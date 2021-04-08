class Answer < ApplicationRecord
  belongs_to :card
  belongs_to :player

  validate :game_has_started?, on: :update

  scope :correct, -> { where(correct: true) }

  def correct?(card, attempt)
    deck = game_user.game.decks.find(card.deck)
    attempt == (deck.inverted? ? card.back : card.front)
  end

  def game_has_started?
    game_user.game.active?
  end
end
