class PlayChannel < ApplicationCable::Channel
  periodically :transmit_remaining_time, every: 1.second

  def subscribed
    return reject if reject?

    stream_for play
  end

  def unsubscribed
  end

  def receive(data)
    receive_answers(data["answers"])
  end

  def receive_answers(answers)
    answers.each do |answer|
      card_id = answer["cardId"].to_i
      attempt = answer["value"]

      answer = play.answers.find_by(card: card(card_id))

      if answer.present?
        answer.update!(attempt: attempt)
      else
        play.answers.create!(card: card(card_id), attempt: attempt)
      end
    end
  end

  def transmit_remaining_time
    return if reject?

    time_left = play.time_left
    transmit({time_left: "#{time_left}s remaining"})

    return if time_left > 1

    game.stop!(for_player: current_user)
    transmit({time_left: 0})
  end

  def card(id)
    Card.find(id)
  end

  delegate :game, to: :play

  def play
    Play.find_by!(id: params[:id], user: current_user)
  end

  def reject?
    game.blank? || game.stopped? || play.blank? || play.stopped? || play.time_left < 1
  end
end
