import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['file']

  updateSelectedFile (evt) {
    this.fileTarget.textContent = evt.target.value.split('\\').pop()
  }
}
