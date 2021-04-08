import {Controller} from "stimulus"

export default class extends Controller {
  static targets = ["card"]
  static values = {index: Number}

  next() {
    this.previousIndex = this.indexValue

    if (this.indexValue === this.totalCards()) {
      this.indexValue = this.totalCards()
    } else {
      this.indexValue++
    }
  }

  previous() {
    this.previousIndex = this.indexValue

    if (this.indexValue === 0) {
      this.indexValue = 0
    } else {
      this.indexValue--
    }
  }
  
  indexValueChanged() {
    this.hideAllCards()
    this.currentCard.hidden = false
  }

  hideAllCards() {
    this.cardTargets.forEach(element => element.hidden = true)
  }

  totalCards() {
    return this.cardTargets.length - 1
  }

  get currentCard() {
    return this.cardTargets[this.indexValue]
  }

  get previousCard() {
    return this.cardTargets[this.previousIndex]
  }

  state() {
    return this.cardTargets.map(card => this.state_for(card))
  }

  state_for(card) {
    return {
      id: card.dataset.cardId,
      value: card.querySelector(".input").value
    }
  }
}
