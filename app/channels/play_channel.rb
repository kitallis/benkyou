class PlayChannel < ApplicationCable::Channel
  def subscribed
    return reject if play.stopped?
    stream_for play
  end

  def unsubscribed
  end

  def receive(data)
    data['answers'].each do |answer|
      card_id = answer['cardId'].to_i
      attempt = answer['value']

      answer = play.answers.find_by(card: card(card_id))

      if answer.present?
        answer.update!(attempt: attempt)
      else
        play.answers.create!(card: card(card_id), attempt: attempt)
      end
    end
  end

  def card(id)
    Card.find(id)
  end

  def play
    Play.find(params[:id])
  end
end
