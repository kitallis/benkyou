class Game < ApplicationRecord
  include State

  has_many :game_decks, autosave: true
  has_many :plays, autosave: true
  has_many :decks, through: :game_decks
  has_many :cards, through: :decks
  has_many :users, through: :plays

  enum status: STATUSES

  validates :name, :length, presence: true
  validates :length, numericality: { only_integer: true }
  validate :at_least_one_player?, on: [:create, :update]
  validate :at_least_one_game_deck?, on: [:create, :update]

  def players
    plays.includes(:user).map(&:user)
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

  def stop!
    raise InvalidStatusChange unless stopped? || started?

    update!(status: :stopped) if plays.all?(&:stopped?)
  end

  private

  def at_least_one_player?
    if plays.empty?
      errors.add(:plays, "need at least one player")
    end
  end

  def at_least_one_game_deck?
    if game_decks.empty?
      errors.add(:game_decks, "attach at least 1 game deck")
    end
  end
end
