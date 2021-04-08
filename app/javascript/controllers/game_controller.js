import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["timeLeft"];

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "GameChannel",
        id: this.data.get("id"),
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
      }
    );
  }

  _received(data) {
    const element = this.timeLeftTarget

    if (parseInt(data.time_left) === 0) {
      alert("Game has ended!")
      this.subscription.unsubscribe();
    }

    element.innerHTML = data.time_left

  }

  _connected() {}
  _disconnected() {}
}
