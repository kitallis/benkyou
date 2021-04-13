class PlayChannel < ApplicationCable::Channel
  periodically :transmit_remaining_time, every: 2.seconds

  def subscribed
    return reject if reject?

    stream_for play
  end

  def unsubscribed

  end

  def receive(data)
    receive_answer(data["answer"])
  end

  def receive_answer(new_answer)
    return stop_stream_for(play) if play.time_up?

    params = {
      card_id: new_answer["cardId"].to_i,
      attempt: new_answer["attempt"]
    }

    play.upsert_answer!(params)
  end

  def transmit_remaining_time
    return stop_stream_for(play) if reject?

    if play.time_up?
      play.time_up!
      transmit({ time_left_perc: 0.0 })
      stop_stream_for(play)
    else
      transmit({ time_left_perc: play.time_left_perc })
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
