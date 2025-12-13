FactoryBot.define do
  # TODO: Remove this factory after implementing credit_account
  factory :payment_method do
    name { Faker::Lorem.word }
    type { 'DebitAccount' } # TODO: implement CreditAccount
    balance { 100 }
  end

  factory :debit_account do
    name { "#{Faker::Lorem.word} Debit" }
    type { 'DebitAccount' }
    balance { 100 }
  end

  factory :credit_account do
    name { "#{Faker::Lorem.word} Credit" }
    type { 'CreditAccount' }
    balance { 100 }
  end
end
