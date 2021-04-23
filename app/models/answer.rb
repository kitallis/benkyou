class Answer < ApplicationRecord
  belongs_to :play
  belongs_to :card

  scope :correct, -> { where(correct: true) }

  validate -> { !play.finished? }, on: [:create, :update]

  delegate :game, to: :play

  before_save do
    self.correct = correct?
  end

  def correct?
    sanitize(card.back).eql?(sanitize(attempt))
  end

  def sanitize(word)
    word.downcase.squish
  end
end
