FactoryBot.define do
  factory :expense do
    amount { 1.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    type { 'Expense' }
    category
  end

  factory :income do
    amount { 2.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    type { 'Income' }
  end
end
