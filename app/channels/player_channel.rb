class PlayerChannel < ApplicationCable::Channel
  def subscribed
    stream_for player
  end

  def unsubscribed
  end

  def receive(data)
    data['answers'].each do |answer|
      card_id = answer['cardId'].to_i
      attempt = answer['value']

      answer = player.answers.find_by(card: card(card_id))

      if answer.present?
        answer.update!(attempt: attempt)
      else
        player.answers.create!(card: card(card_id), attempt: attempt)
      end
    end
  end

  def card(id)
    Card.find(id)
  end

  def player
    Player.find(params[:id])
  end
end
