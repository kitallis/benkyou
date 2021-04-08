class GameChannel < ApplicationCable::Channel
  periodically :transmit_remaining_time, every: 1.second

  def subscribed
    game = game(params[:id])
    game_user = game_user(game)

    return reject unless game.exists?
    return reject unless game_user.exists?
    return reject if game_user.first.time_left < 1

    stream_for game
  end

  def unsubscribed; end

  def transmit_remaining_time
    game = game(params[:id])
    game_user = game_user(game)

    return unless game.first.playing?
    return unless game.exists?
    return unless game_user.exists?

    time_left = game_user.first.time_left
    transmit({ time_left: "#{time_left}s remaining" })

    return if time_left > 1

    game_user.first.stop!
    transmit({ time_left: 'TIME IS UP' })
  end

  def game(id)
    Game.where(id: id)
  end

  def game_user(game)
    GameUser.where(game: game, user: current_user)
  end
end
