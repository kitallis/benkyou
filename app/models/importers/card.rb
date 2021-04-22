class Importers::Card
  include CSVImporter

  model Card

  column :front, as: [/front/i, "question", "q"], required: true
  column :back, as: [/back/i, "answer", "a"], to: ->(value) { value.downcase }, required: true
end
