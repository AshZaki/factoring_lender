FactoryBot.define do
  factory :fee do
    fee_amount { 5.0 }
    fee_date { Date.today }
    association :invoice
  end
end