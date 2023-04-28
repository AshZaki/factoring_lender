class Invoice < ApplicationRecord
  belongs_to :client
  has_one_attached :invoice_scan
  has_many :fees

  validates :invoice_number, presence: true, uniqueness: true
  enum status: { created: 0, rejected: 1, approved: 2, purchased: 3, closed: 4 }

  def accrue_fee!
    # Only add the fee if the invoice's state is "purchased"
    if status == "purchased"
      # Calculate the additional fee (1% of the invoice_amount)
      additional_fee = invoice_amount * 0.01

      # Update the fees by adding the additional_fee
      update(fees: fees + additional_fee)
    end
  end
end
