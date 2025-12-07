FactoryBot.define do
  factory :expense do
    amount { 1.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    type { 'Expense' }
    category_id { create(:category).id }
    payment_method_id { create(:payment_method).id }
  end

  factory :income do
    amount { 2.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    type { 'Income' }
    payment_method_id { create(:payment_method).id }
  end
end
