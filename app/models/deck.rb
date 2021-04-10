class Deck < ApplicationRecord
  has_many :cards

  scope :search, ->(term) { where("name LIKE ?", "%#{term}%") }

  enum difficulty: {
    v_easy: "v_easy",
    easy: "easy",
    medium: "medium",
    hard: "hard",
    v_hard: "v_hard"
  }

  validates :name, :difficulty, presence: true
end
