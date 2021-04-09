class Answer < ApplicationRecord
  belongs_to :play
  belongs_to :card
  validate -> { game.started? }, on: :update
  scope :correct, -> { where(correct: true) }
  delegate :game, to: :play

  def correct?(attempt)
    card.back.eql?(attempt)
  end
end
