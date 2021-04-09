class Deck < ApplicationRecord
  has_many :cards

  enum difficulty: {
    v_easy: "v_easy",
    easy: "easy",
    medium: "medium",
    hard: "hard",
    v_hard: "v_hard"
  }
end
