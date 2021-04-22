class Card < ApplicationRecord
  belongs_to :deck
  validates :front, :back, presence: true

  paginates_per 10
end
