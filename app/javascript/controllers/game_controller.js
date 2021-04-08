import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["timeLeft"];

  connect() {
    this.gameSubscription = consumer.subscriptions.create(
      {
        channel: "GameChannel",
        id: this.data.get("id"),
      },
      {
        connected: this._connected.bind(this),
        received: this._received.bind(this),
        disconnected: this._disconnected.bind(this),
      }
    );
  }

  _received(data) {
    this.updateTimeLeft(data)
    this.checkPlayStatus(data)
  }

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

  unsubscribe() {
    this.gameSubscription.unsubscribe();
  }

  _connected() {}
  _disconnected() {}
}
