import { Controller } from 'stimulus'
import consumer from 'channels/consumer'
import Rails from '@rails/ujs'

export default class extends Controller {
  static targets = ["timeLeft", "playForm"];

  connect () {
    this.channel = consumer.subscriptions.create(
      {
        channel: 'PlayChannel',
        id: this.data.get('id')
      },
      {
        connected: this._connected.bind(this),
        received: this._received.bind(this),
        disconnected: this._disconnected.bind(this)
      }
    )
  }

  initialize () {
    console.log("INIT'd play")

    // https://dev.to/leastbad/the-best-one-line-stimulus-power-move-2o90
    this.element[this.identifier] = this
  }

  _received (data) {
    this.updateTimeLeft(data)
    this.checkPlayStatus(data)
  }

  _connected () {}
  _disconnected () {}

  checkPlayStatus (data) {
    if (this.hasPlayEnded(data)) {
      this.finishPlay()
    }
  }

  updateTimeLeft (data) {
    this.timeLeftTarget.setAttribute("value", data.time_left_perc)
  }

  hasPlayEnded (data) {
    return parseInt(data.time_left_perc) === 0.0
  }

  finishPlay () {
    alert('Game has ended!')
    this.unsubscribe()
    this.submit()
  }

  submit() {
    Rails.fire(this.playFormTarget, 'submit')
  }

  get subscription () {
    return this.channel
  }

  unsubscribe () {
    this.channel.unsubscribe()
  }
}
