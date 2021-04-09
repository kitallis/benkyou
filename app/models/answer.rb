class Answer < ApplicationRecord
  belongs_to :play
  belongs_to :card

  validate :game_has_started?, on: :update

  scope :correct, -> { where(correct: true) }

  delegate :game, to: :play

  def game_started?
    game.started?
  end

  def correct?(attempt)
    card.back == attempt
  end
end
