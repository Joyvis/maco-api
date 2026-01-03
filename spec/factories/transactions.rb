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
      paid_at { Date.today }
    end

    trait :overdue do
      due_date { Date.yesterday }
    end
  end

  factory :income do
    amount { 2.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    type { 'Income' }
    payment_method_id { create(:payment_method).id }
  end

  factory :invoice do
    amount { 2.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }
    type { 'Invoice' }
    payment_method_id { create(:payment_method).id }
    trait :paid do
      paid_at { Date.today }
    end
    transient do
      invoice_items_count { 2 }
    end
    trait :invoice_items do
      after(:create) do |invoice, evaluator|
        create_list(:expense, evaluator.invoice_items_count, invoice_id: invoice.id)
      end
    end
  end
end
