class Card < ApplicationRecord
  belongs_to :deck
  validates :front, :back, presence: true
end
