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

  def winners
    return [] unless stopped?

    play_info = plays.map { |play| [play, { score: play.score, time_taken: play.time_taken }] }.to_h
    highest_score = play_info.values.flatten.map { |info| info[:score] }.max

    highest_scorers = play_info.filter { |_, info| info[:score].eql?(highest_score) }
    return highest_scorers.first if highest_scorers.size == 1

    quickest = highest_scorers.values.flatten.map { |s| s[:time_taken] }.min
    highest_scorers.filter { |_, info| info[:time_taken].eql?(quickest) }
  end

  def players
    plays.includes(:user).map(&:user)
  end

  def start!
    raise InvalidStatusChange if stopped?
    return if started?

    update!(status: :started)
  end

  def stop!
    raise InvalidStatusChange if created?
    return if stopped?

    update!(status: :stopped) if plays.all? { |play| play.stopped? || play.time_up? }
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
