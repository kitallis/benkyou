import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["status"];

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

  _connected() {}

  _disconnected() {}

  _received(data) {
    const element = this.statusTarget
    element.innerHTML = data.time_left
  }
}
