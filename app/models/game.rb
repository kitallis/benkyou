class Game < ApplicationRecord
  class InvalidStatusChange < StandardError; end

  has_many :game_decks
  has_many :plays
  has_many :decks, through: :game_decks
  has_many :cards, through: :decks
  has_many :users, through: :plays

  enum status: {
    created: "created",
    started: "started",
    stopped: "stopped"
  }

  before_create do
    self.status = :created
  end

  def create_with_player!(player)
    transaction do
      save!
      add_player!(player)
      true
    end
  end

  def add_player!(player)
    plays.create!(user: player)
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
