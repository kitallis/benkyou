import {Controller} from "stimulus"
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["card"]
  static values = {index: Number}

  connect() {
    this.playerSubscription = consumer.subscriptions.create(
      {
        channel: "PlayerChannel",
        id: this.data.get("playerid"),
      },
      {
        connected: this._connected.bind(this),
        received: this._received.bind(this),
        disconnected: this._disconnected.bind(this),
      }
    );
  }

  _connected() {}
  _received(data) {}
  _disconnected() {}

  next() {
    this.previousIndex = this.indexValue

    this.updateAnswer()

    if (this.indexValue === this.totalCards()) {
      this.indexValue = this.totalCards()
    } else {
      this.indexValue++
    }
  }

  previous() {
    this.previousIndex = this.indexValue

    this.updateAnswer()

    if (this.indexValue === 0) {
      this.indexValue = 0
    } else {
      this.indexValue--
    }
  }

  updateAnswer() {
    this.playerSubscription.send({answers: [this.state_for(this.previousCard)]})
  }

  indexValueChanged() {
    this.hideAllCards()
    this.currentCard.hidden = false
  }

  hideAllCards() {
    this.cardTargets.forEach(element => element.hidden = true)
  }

  totalCards() {
    return this.cardTargets.length - 1
  }

  get currentCard() {
    return this.cardTargets[this.indexValue]
  }

  get previousCard() {
    return this.cardTargets[this.previousIndex]
  }

  state() {
    return this.cardTargets.map(card => this.state_for(card))
  }

  state_for(card) {
    return {
      cardId: card.dataset.cardId,
      value: card.querySelector(".input").value
    }
  }
}
