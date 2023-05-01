FactoryBot.define do
    factory :invoice do
      association :client
  
      sequence(:invoice_number) { |n| "INV#{n}" }
      invoice_amount { 100.00 }
      status { "created" }
      due_date { Faker::Date.between(from: 30.days.ago, to: 30.days.from_now) }
      purchased_at { DateTime.current - rand(1..10).days if status == "purchased" }
  
      after(:build) do |invoice|
        invoice.invoice_scan.attach(io: File.open(Rails.root.join('spec', 'support', 'assets', 'sample.pdf')), filename: 'sample.pdf', content_type: 'application/pdf') unless invoice.invoice_scan.attached?
      end
    end
  end
  