FactoryBot.define do
  factory :transaction do
    type { 'Expense' }
    amount { 1.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    category
  end
end
