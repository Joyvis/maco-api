class Transaction < ApplicationRecord
  belongs_to :payment_method
  after_create :update_payment_method_balance

  scope :not_invoices, -> { where(invoice_id: nil) }
  scope :paid, -> { where.not(paid_at: nil) }
  scope :not_paid, -> { where(paid_at: nil) }

  validates :description, :amount, :due_date, presence: true

  ransacker :due_date_month do
    Arel.sql("EXTRACT(MONTH FROM due_date)")
  end

  ransacker :due_date_year do
    Arel.sql("EXTRACT(YEAR FROM due_date)")
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "amount",
      "payment_method_id",
      "category_id",
      "due_date_year",
     "due_date_month"
    ]
  end

  private

  def update_payment_method_balance
    # THERE IS SOMETHING WRONG WITH THIS LOGIC lol
    transaction_amount = amount
    if payment_method.type == "DebitAccount"
      transaction_amount *= -1 if type == "Income"
    else
      transaction_amount *= -1 if type == "Expense"
    end

    payment_method.update!(
      balance: payment_method.balance - transaction_amount
    )
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
