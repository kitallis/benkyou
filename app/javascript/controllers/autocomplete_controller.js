import { Controller } from 'stimulus'
import autocomplete from 'autocomplete.js'
import Rails from '@rails/ujs'
import Mustache from 'mustache'

export default class extends Controller {
  static targets = ['field', 'suggestionTemplate', 'selectionTemplate', 'selectionInsert', 'insertedSelection'];

  source () {
    return (query, callback) => {
      Rails.ajax({
        type: 'get',
        url: this.data.get('url'),
        data: this.queryData(query),
        success: function (data) {
          callback(data)
        }
      })
    }
  }

  queryData (query) {
    return 'q=' + query
  }

  connect () {
    const suggestionTemplate = this.suggestionTemplateTarget.innerHTML
    const selectionTemplate = this.selectionTemplateTarget.innerHTML

    autocomplete(this.fieldTarget, { hint: false, minLength: 3 }, [
      {
        source: this.source(),
        debounce: 200,
        templates: {
          suggestion: (suggestion) => {
            return Mustache.render(suggestionTemplate, suggestion)
          }
        }
      }
    ]).on('autocomplete:selected', (event, suggestion, dataset, context) => {
      const previouslyInserted = this.insertedSelectionTargets.find(element => element.dataset.selectedId === suggestion.id)

      if (!previouslyInserted) {
        this.selectionInsertTarget.innerHTML += Mustache.render(selectionTemplate, suggestion)
      }
    })
  }
}
