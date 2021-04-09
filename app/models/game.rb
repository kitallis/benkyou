class Game < ApplicationRecord
  include State

  has_many :game_decks
  has_many :plays
  has_many :decks, through: :game_decks
  has_many :cards, through: :decks
  has_many :users, through: :plays
  enum status: STATUSES
  validates :name, :length, presence: true
  validates :length, numericality: { only_integer: true }

  def create_with_player!(player)
    transaction do
      save!
      add_player!(player)
      true
    end
  end

  def players
    plays.includes(:user).map(&:user)
  end

  def add_player!(player)
    plays.create!(user: player)
  end

  def plays_over?
    plays.all? { |play| play.time_up? || play.stopped? }
  end

  # This won't run into a race condition since the Game can go from 'playing' to 'playing'
  # i.e. not break if the 'playing' status is re-applied during a game start by another player
  def start!(for_player:)
    raise InvalidStatusChange unless created? || started?

    transaction do
      plays.where(user: for_player).first.play!
      update!(status: :started)
    end
  end

  def stop!(for_player:)
    raise InvalidStatusChange unless stopped? || started?

    transaction do
      plays.where(user: for_player).first.stop!
      update!(status: :stopped) if plays.all?(&:stopped?)
    end
  end
end
