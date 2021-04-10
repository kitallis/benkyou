import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['notification']

  kill () {
    const element = this.notificationTarget
    element.parentNode.remove()
  }
}
