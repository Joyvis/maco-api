FactoryBot.define do
  factory :payment_method do
    name { Faker::Lorem.word }
    type { 'DebitAccount' } # TODO: implement CreditAccount
    balance { 100 }
  end
end
