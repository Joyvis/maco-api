class DebitAccount < PaymentMethod
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
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
#
