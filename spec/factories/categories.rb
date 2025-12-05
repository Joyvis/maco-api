FactoryBot.define do
  factory :category do
    name { Faker::Lorem.word }
    percent { nil }
  end
end
