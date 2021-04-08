import {Controller} from "stimulus"
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["playCard"]
  static values = {index: Number}

  connect() {
    this.playSubscription = consumer.subscriptions.create(
      {
        channel: "PlayChannel",
        id: this.data.get("id"),
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

  initialize() {
    console.log("INITd play")
    // this.removePlayerSubscriptionHandler();
  }

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
    this.playSubscription.send({answers: [this.stateFor(this.previousCard)]})
  }

  indexValueChanged() {
    this.hideAllCards()
    this.currentCard.hidden = false
  }

  hideAllCards() {
    this.playCardTargets.forEach(element => element.hidden = true)
  }

  totalCards() {
    return this.playCardTargets.length - 1
  }

  get currentCard() {
    return this.playCardTargets[this.indexValue]
  }

  get previousCard() {
    return this.playCardTargets[this.previousIndex]
  }

  state() {
    return this.playCardTargets.map(playCard => this.stateFor(playCard))
  }

  stateFor(playCard) {
    return {
      cardId: playCard.dataset.cardId,
      value: playCard.querySelector(".input").value
    }
  }

  removePlayerSubscriptionHandler() {
    this.addEventListener("remove-play-subscription", (e) => {
      this.playSubscription.unsubscribe();
    });
  }
}
