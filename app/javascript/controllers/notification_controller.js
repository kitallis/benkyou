import {Controller} from "stimulus"

export default class extends Controller {
  static targets = ["notification"]

  kill() {
    let element = this.notificationTarget
    element.parentNode.remove()
  }
}
