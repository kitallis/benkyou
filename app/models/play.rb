class Play < ApplicationRecord
  include State

  belongs_to :game
  belongs_to :user
  has_many :answers
  delegate :cards, to: :game

  def questions
    attempted_answers = answers.includes(:card).where(card: cards)
    result = cards.map do |card|
      {
        card: card,
        attempted_answer: attempted_answers.find { |a| a.card == card }
      }
    end

    # questions for a play should be repeatably shuffled
    result.sort_by { id }
  end

  def score
    answers.correct.size
  end

  def time_left
    game.length - time_elapsed
  end

  def time_elapsed
    return -1 if started_at.blank?

    Time.now.to_i - started_at.to_i
  end

  def submit!(submissions)
    transaction do
      answers.create!(submissions)
      stop!
    end
  end

  def play!
    raise InvalidStatusChange unless created? || started?

    update!(status: :started, started_at: Time.now)
  end

  def stop!
    raise InvalidStatusChange unless stopped? || started?

    update!(status: :stopped)
  end
end
