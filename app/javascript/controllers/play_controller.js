import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["timeLeft"];

  connect() {
    this.channel = consumer.subscriptions.create(
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

  initialize() {
    console.log("INITd game")

    // https://dev.to/leastbad/the-best-one-line-stimulus-power-move-2o90
    this.element[this.identifier] = this
  }

  _received(data) {
    this.updateTimeLeft(data)
    this.checkPlayStatus(data)
  }

  _connected() {}
  _disconnected() {}

  checkPlayStatus(data) {
    if (this.has_play_ended(data)) {
      alert("Game has ended!")
      this.unsubscribe()
    }
  }

  updateTimeLeft(data) {
    const element = this.timeLeftTarget
    element.innerHTML = data.time_left
  }

  has_play_ended(data) {
    return parseInt(data.time_left) === 0
  }

  get subscription() {
    return this.channel
  }

  unsubscribe() {
    this.channel.unsubscribe()
  }
}
