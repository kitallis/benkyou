class AnswerChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed; end

  def receive(data)
    puts "RECEIVE BY SERVER"
  end

  def game(id)
    Game.find(id)
  end

  def game_user(game)
    GameUser.where(game: game, user: current_user).first
  end
end
