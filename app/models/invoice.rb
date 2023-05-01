class Invoice < ApplicationRecord
  belongs_to :client
  has_one_attached :invoice_scan
  has_many :fees

  validates :invoice_number, presence: true, uniqueness: { case_sensitive: false }
  validates :invoice_amount, numericality: { greater_than_or_equal_to: 0 }
  enum status: { created: 0, rejected: 1, approved: 2, purchased: 3, closed: 4 }

  after_save :set_purchased_at, if: :purchased_status_changed?

  def accrue_fee!(interest_rate = 0.01)
    # Only add the fee if the invoice's state is "purchased" and purchased_at is present
    if status == "purchased" && purchased_at.present?
      # Calculate the days since the invoice was purchased
      days_since_purchased = (Date.current - purchased_at.to_date).to_i

      # Calculate the daily interest rate
      daily_interest_rate = (1 + interest_rate) ** (1.0 / 365) - 1

      # Calculate the additional fee
      additional_fee = invoice_amount * (1 + daily_interest_rate) ** days_since_purchased - invoice_amount
  
      # Create a new fee record and associate it with the invoice
      fees.create(fee_amount: additional_fee, fee_date: Date.current)

      # Update the invoice_amount in the invoices table
      update(invoice_amount: invoice_amount + additional_fee)

    end
  end
  
  private
  def purchased_status_changed?
    saved_change_to_status? && status == "purchased"
  end

  def set_purchased_at
    update_column(:purchased_at, DateTime.current) if purchased_at.nil?
  end
end
