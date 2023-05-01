class Fee < ApplicationRecord
  belongs_to :invoice

  validates :fee_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
