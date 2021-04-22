import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['card', 'cards']
  static values = { index: Number }

  initialize () {
    console.log("INIT'd card")
    this.channel = document.querySelector('#play').play.subscription
  }

  next () {
    this.previousIndex = this.indexValue

    this.updateAnswer()

    if (this.indexValue === this.totalCards()) {
      this.indexValue = this.totalCards()
    } else {
      this.indexValue++
    }
  }

  previous () {
    this.previousIndex = this.indexValue

    this.updateAnswer()

    if (this.indexValue === 0) {
      this.indexValue = 0
    } else {
      this.indexValue--
    }
  }

  updateAnswer () {
    this.channel.send({ answer: this.stateFor(this.previousCard) })
  }

  indexValueChanged () {
    this.hideAllCards()
    this.currentCard.hidden = false
    this.currentCard.focus()
  }

  writeMode () {
    this.currentCard.getElementsByClassName('attempt')[0].focus()
    return false
  }

  hideAllCards () {
    this.cardTargets.forEach(element => { element.hidden = true })
  }

  totalCards () {
    return this.cardTargets.length - 1
  }

  get currentCard () {
    return this.cardTargets[this.indexValue]
  }

  get previousCard () {
    return this.cardTargets[this.previousIndex]
  }

  stateFor (card) {
    return {
      cardId: card.dataset.cardId,
      attempt: card.querySelector('.input').value
    }
  }
}
