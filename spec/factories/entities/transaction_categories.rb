FactoryBot.define do
  factory :transaction_category_entity,
    class: 'Finances::Entities::TransactionCategory' do
      name { Faker::Lorem.word }
  end
end
