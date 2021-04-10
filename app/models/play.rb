class Play < ApplicationRecord
  include State

  belongs_to :game
  belongs_to :user
  has_many :answers

  enum status: STATUSES.merge(time_up: "time_up")

  delegate :cards, to: :game

  def questions
    attempted_answers = answers.includes(:card).where(card: cards)
    result = cards.map do |card|
      {
        card: card,
        attempted_answer: attempted_answers.find { |a| a.card.eql?(card) }
      }
    end

    # questions for a play should be repeatably shuffled
    result.sort_by { id }
  end

  def score
    answers.correct.size
  end

  # FIXME: this method is confusing
  def finished?
    stopped? || game.stopped?
  end

  def time_up?
    time_left < 1
  end

  def time_left_perc
    100.0 * time_left / game.length
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

  def time_up!
    raise InvalidStatusChange unless time_up? || started?

    update!(status: :time_up)
  end

  def stop!
    raise InvalidStatusChange unless stopped? || started? || time_up?

    update!(status: :stopped)
  end
end
