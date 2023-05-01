FactoryBot.define do
    factory :client do
      name { Faker::Name.unique.name }
    end
  end
  