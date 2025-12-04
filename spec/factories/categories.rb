FactoryBot.define do
  factory :category do
    name { Faker::Lorem.word }
    percent { Random.rand(1..100) }
  end
end
