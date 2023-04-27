class Invoice < ApplicationRecord
  belongs_to :client
  has_one_attached :invoice_scan
  has_many :fees

  validates :invoice_number, uniqueness: true
  enum status: { created: 0, rejected: 1, approved: 2, purchased: 3, closed: 4 }
end
