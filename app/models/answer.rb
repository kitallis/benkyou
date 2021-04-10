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
    card.back.eql?(sanitize_attempt)
  end

  def sanitize_attempt
    attempt.downcase.squish
  end
end
