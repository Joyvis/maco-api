FactoryBot.define do
  factory :credit_account_payment_method_entity,
    class: 'Finances::Entities::CreditAccountPaymentMethod' do
    name { Faker::Lorem.word }
    due_day { 20 }
  end
end
