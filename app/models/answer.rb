class Answer < ApplicationRecord
  belongs_to :play
  belongs_to :card

  scope :correct, -> { where(correct: true) }

  validate -> { !play.finished? }, on: [:create, :update]

  delegate :game, to: :play

  def correct?(attempt)
    card.back.eql?(attempt)
  end
end
