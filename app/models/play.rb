class Play < ApplicationRecord
  include State

  belongs_to :game
  belongs_to :user
  has_many :answers

  enum status: STATUSES.merge(time_up: "time_up")

  delegate :cards, to: :game
  alias_method :player, :user

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

  def time_taken
    return game.length if stopped_at.nil?
    stopped_at.to_i - started_at.to_i
  end

  def submit!(submissions)
    transaction do
      submissions.each { |s| upsert_answer!(s) }
      stop!
      game.stop!
    end
  end

  def upsert_answer!(new_answer)
    attempt = new_answer[:attempt]
    card_id = new_answer[:card_id]

    answer = answers.find_or_initialize_by(card_id: card_id)
    answer.attempt = attempt
    answer.save!
  end

  def start!
    raise InvalidStatusChange if finished? || time_up?
    return if started?

    transaction do
      game.start!
      update!(status: :started, started_at: Time.now)
    end
  end

  def time_up!
    raise InvalidStatusChange if finished? || created?
    return if time_up?

    update!(status: :time_up)
  end

  def stop!
    update!(status: :stopped, stopped_at: Time.current)
  end
end
