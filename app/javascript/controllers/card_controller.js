import {Controller} from "stimulus"

export default class extends Controller {
  static targets = ["card"]
  static values = {index: Number}

  next() {
    if (this.indexValue === this.totalCards()) {
      this.indexValue = this.totalCards()
    } else {
      this.indexValue++
    }
  }

  previous() {
    if (this.indexValue === 0) {
      this.indexValue = 0
    } else {
      this.indexValue--
    }
  }

  indexValueChanged() {
    this.showCurrentCard()
  }

  showCurrentCard() {
    this.cardTargets.forEach((element, index) => {
      element.hidden = index != this.indexValue
    })
  }

  totalCards() {
    return this.cardTargets.length - 1
  }
}
