FactoryBot.define do
  factory :invoice_transaction_entity,
    class: 'Finances::Entities::InvoiceTransaction' do
    amount { 2.00 }
    due_date { Date.today }
    description { Faker::Lorem.sentence }

    # payment_method_id { create(:payment_method).id }
    # trait :paid do
    #   paid_at { Date.today }
    # end
    # transient do
    #   invoice_items_count { 2 }
    # end
    # trait :invoice_items do
    #   after(:create) do |invoice, evaluator|
    #     create_list(:expense, evaluator.invoice_items_count, invoice_id: invoice.id)
    #   end
    # end
  end
end
