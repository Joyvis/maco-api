FactoryBot.define do
  factory :expense do
    amount { 1.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    type { 'Expense' }
    category_id { create(:category).id }
    payment_method_id { create(:payment_method).id }
    paid_at { nil }

    trait :paid do
      paid_at { Date.tomorrow }
    end

    trait :overdue do
      due_date { Date.yesterday }
    end

    trait :invoice_items do
      after(:create) do |expense|
        create_list(:expense, 2, invoice_id: expense.id)
      end
    end
  end

  factory :income do
    amount { 2.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    type { 'Income' }
    payment_method_id { create(:payment_method).id }
  end
end
