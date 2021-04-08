class GameChannel < ApplicationCable::Channel
  periodically :transmit_remaining_time, every: 1.second

  def subscribed
    game = game(params[:id])
    game_user = game_user(game)

    return reject unless game.present?
    return reject unless game_user.present?
    return reject if game_user.time_left < 1

    stream_for game
  end

  def unsubscribed; end

  def transmit_remaining_time
    game = game(params[:id])
    game_user = game_user(game)

    return unless game.present?
    return unless game.playing?
    return unless game_user.present?
    return unless game_user.playing?

    time_left = game_user.time_left
    transmit({ time_left: "#{time_left}s remaining" })
    return unless time_left < 1

    game.stop!(for_player: current_user)
    transmit({ time_left: 0 }) if time_left < 1
  end

  def game(id)
    Game.find(id)
  end

  def game_user(game)
    GameUser.where(game: game, user: current_user).first
  end
end
