class Player < ApplicationRecord
  class InvalidStatusChange < StandardError; end

  has_many :answers
  belongs_to :game
  belongs_to :user

  enum status: {
    ready: 'ready',
    playing: 'playing',
    stopped: 'stopped'
  }

  before_create do
    self.status = :ready
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

  def play!
    raise InvalidStatusChange unless ready? || playing?

    update!(status: :playing, started_at: Time.now)
  end

  def stop!
    raise InvalidStatusChange unless stopped? || playing?

    update!(status: :stopped)
  end
end
