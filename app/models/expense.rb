class Expense < Transaction
  belongs_to :category

  belongs_to :invoice, foreign_key: :invoice_id, optional: true

  # VALIDATION:
  # when creating a transaction with a category that contains percent present
  # we need ensure that the sum of all category percent is equal to 100
  validate :validate_category_percent,
    if: -> { category && category.percent.present? }
  validates :category, presence: true

  def self.create_transaction!(transaction_params)
    transaction = new(transaction_params)

    if transaction&.payment_method&.type == "CreditAccount"
      transaction.invoice_id = transaction.setup_invoice(transaction).id
    end
    transaction.save!
    transaction
  end

  def setup_invoice(transaction)
    invoice = Invoice.find_by(
      description: transaction.payment_method.name + " Invoice",
      due_date: calculate_next_due_date(transaction.payment_method),
      payment_method_id: transaction.payment_method_id,
      paid_at: nil
    )

    return invoice if invoice

    Invoice.create(
      description: transaction.payment_method.name + " Invoice",
      due_date: calculate_next_due_date(transaction.payment_method),
      payment_method_id: transaction.payment_method_id,
      amount: transaction.amount
    )
  end

  def calculate_next_due_date(payment_method)
    next_month = Date.today
    next_month = next_month.next_month if next_month.day > payment_method.due_day

    next_month = next_month.beginning_of_month
    next_month + (payment_method.due_day - 1).days
  end

  private

  def validate_category_percent
    total = Category.where.not(percent: nil).sum(:percent)
    errors.add(:category, "category percentages must sum to 100") if total != 100
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
#  paid_at           :datetime
#  invoice_id        :uuid
#
# Indexes
#
#  index_transactions_on_category_id        (category_id)
#  index_transactions_on_invoice_id         (invoice_id)
#  index_transactions_on_payment_method_id  (payment_method_id)
#
