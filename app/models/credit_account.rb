class CreditAccount < PaymentMethod
  validates :due_day, presence: true
end

# == Schema Information
#
# Table name: payment_methods
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  balance    :float            not null
#  due_day    :integer
#
