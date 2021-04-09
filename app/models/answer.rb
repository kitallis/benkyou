class Answer < ApplicationRecord
  belongs_to :play
  belongs_to :card
  validate -> { play.started? && game.started? }, on: [:create, :update]
  scope :correct, -> { where(correct: true) }
  delegate :game, to: :play

  def correct?(attempt)
    card.back.eql?(attempt)
  end
end
