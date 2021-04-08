class GameChannel < ApplicationCable::Channel
  periodically :transmit_remaining_time, every: 1.second

  def subscribed
    play = play(game)

    return reject if game.blank? || play.blank?
    return reject if play.time_left < 1

    stream_for game
  end

  def unsubscribed; end

  def transmit_remaining_time
    play = play(game)

    return if game.blank? || !game.playing?
    return if play.blank? || !play.playing?

    time_left = play.time_left
    transmit({ time_left: "#{time_left}s remaining" })
    return unless time_left < 1

    game.stop!(for_player: current_user)
    transmit({ time_left: 0 }) if time_left < 1
  end

  def game
    Game.find(params[:id])
  end

  def play(game)
    Play.where(game: game, user: current_user).first
  end
end
