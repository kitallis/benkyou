class PlayerChannel < ApplicationCable::Channel
  periodically :transmit_remaining_time, every: 1.second

  def subscribed
    game = game(params[:id])
    player = player(game)

    return reject unless game.present?
    return reject unless player.present?
    return reject if player.time_left < 1

    stream_for game
  end

  def unsubscribed; end

  def transmit_remaining_time
    game = game(params[:id])
    player = player(game)

    return unless game.present?
    return unless game.playing?
    return unless player.present?
    return unless player.playing?

    time_left = player.time_left
    transmit({ time_left: "#{time_left}s remaining" })
    return unless time_left < 1

    game.stop!(for_player: current_user)
    transmit({ time_left: 0 }) if time_left < 1
  end

  def game(id)
    Game.find(id)
  end

  def player(game)
    Player.where(game: game, user: current_user).first
  end
end
