require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:client) { create(:client) }
  let(:invoice) { create(:invoice, client: client) }
  let(:purchased_invoice) { create(:invoice, client: client, status: :purchased, purchased_at: DateTime.current - 5.days) }
  subject { build(:invoice) }

  describe 'associations' do
    it { should belong_to(:client) }
    it { should have_one_attached(:invoice_scan) }
    it { should have_many(:fees) }
  end

  describe 'validations' do
    it { should validate_presence_of(:invoice_number) }
    it { should validate_uniqueness_of(:invoice_number).case_insensitive }
    it { should validate_numericality_of(:invoice_amount).is_greater_than_or_equal_to(0) }
  end

  describe 'status enum' do
    it { should define_enum_for(:status).with_values(created: 0, rejected: 1, approved: 2, purchased: 3, closed: 4) }
  end

  describe '#accrue_fee!' do
    context 'when the invoice status is purchased and purchased_at is present' do
      it 'creates a new fee' do
        expect { purchased_invoice.accrue_fee! }.to change(purchased_invoice.fees, :count).by(1)
      end

      it 'updates the invoice_amount with the accrued fee' do
        original_amount = purchased_invoice.invoice_amount
        purchased_invoice.accrue_fee!
        expect(purchased_invoice.invoice_amount).to be > original_amount
      end
    end

    context 'when the invoice status is not purchased or purchased_at is not present' do
      it 'does not create a new fee' do
        expect { invoice.accrue_fee! }.not_to change(invoice.fees, :count)
      end

      it 'does not update the invoice_amount' do
        original_amount = invoice.invoice_amount
        invoice.accrue_fee!
        expect(invoice.invoice_amount).to eq(original_amount)
      end
    end
  end
end
