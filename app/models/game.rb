class Game < ApplicationRecord
  class InvalidStatusChange < StandardError; end

  has_many :game_decks
  has_many :game_users
  has_many :decks, through: :game_decks
  has_many :users, through: :game_users

  enum status: {
    created: 'created',
    playing: 'playing',
    stopped: 'stopped'
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
    game_users.create!(user: player)
  end

  # This won't run into a race condition since the Game can go from 'playing' to 'playing'
  # i.e. not break if the 'playing' status is re-applied during a game start by another player
  def start!(for_player:)
    raise InvalidStatusChange unless created? || playing?

    transaction do
      game_users.where(user: for_player).first.play!
      update!(status: :playing)
      ActionCable.server.broadcast('games', { player: for_player })
    end
  end

  def stop!(for_player:)
    raise InvalidStatusChange unless playing?

    transaction do
      game_users.where(user: for_player).first.stop!
      update!(status: :stopped)
      ActionCable.server.broadcast('games', { player: for_player })
    end
  end

  def questions
    game_decks.flat_map do |game_deck|
      game_deck.cards.map do |card|
        [card.id, game_deck.inverted? ? card.back : card.front]
      end
    end.shuffle
  end
end
