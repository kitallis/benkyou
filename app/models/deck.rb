class Deck < ApplicationRecord
  has_many :cards, dependent: :delete_all

  scope :search, ->(term) { where("name ILIKE ?", "%#{term}%") }

  enum difficulty: {
    v_easy: "v_easy",
    easy: "easy",
    medium: "medium",
    hard: "hard",
    v_hard: "v_hard"
  }

  validates :name, :difficulty, presence: true

  paginates_per 10
end
