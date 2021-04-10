class PlayChannel < ApplicationCable::Channel
  periodically :transmit_remaining_time, every: 2.seconds

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
    return stop_stream_for(play) if play.time_up?

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
    return stop_stream_for(play) if reject?

    if play.time_up?
      play.time_up!
      transmit({time_left_perc: 0.0})
      stop_stream_for(play)
    else
      transmit({time_left_perc: play.time_left_perc})
    end
  end

  def card(id)
    Card.find(id)
  end

  delegate :game, to: :play

  def play
    Play.find_by!(id: params[:id], user: current_user)
  end

  def reject?
    play.blank? || play.finished?
  end
end
