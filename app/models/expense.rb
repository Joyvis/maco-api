class Expense < Transaction
  belongs_to :category

  validates :category, presence: true

  # VALIDATION:
  # when creating a transaction with a category that contains percent present
  # we need ensure that the sum of all category percent is equal to 100
  validate :validate_category_percent

  private

  def validate_category_percent
    return if category.percent.nil?

    total = Category.where.not(percent: nil).sum(:percent)
    errors.add(:category, 'category percentages must sum to 100') if total != 100
  end
end

# == Schema Information
#
# Table name: transactions
#
#  id                :uuid             not null, primary key
#  amount            :decimal(, )      not null
#  type              :string           not null
#  due_date          :date             not null
#  description       :text
#  category_id       :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_method_id :uuid             not null
#
# Indexes
#
#  index_transactions_on_category_id        (category_id)
#  index_transactions_on_payment_method_id  (payment_method_id)
#
