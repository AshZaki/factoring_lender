require 'rails_helper'

RSpec.describe Fee, type: :model do
  let(:invoice) { create(:invoice) }

  describe 'associations' do
    it { should belong_to(:invoice) }
  end

  describe 'validations' do
    it { should validate_presence_of(:fee_amount) }
    it { should validate_numericality_of(:fee_amount).is_greater_than_or_equal_to(0) }
  end

  context 'with valid attributes' do
    let(:fee) { build(:fee, invoice: invoice) }

    it 'is valid' do
      expect(fee).to be_valid
    end
  end

  context 'with invalid attributes' do
    let(:fee_with_negative_amount) { build(:fee, fee_amount: -1, invoice: invoice) }

    it 'is not valid with a negative fee_amount' do
      expect(fee_with_negative_amount).not_to be_valid
      expect(fee_with_negative_amount.errors[:fee_amount]).to include('must be greater than or equal to 0')
    end
  end
end
