class Transaction < ApplicationRecord
  belongs_to :payment_method
  after_create :update_payment_method_balance

  private

  def update_payment_method_balance
    # THERE IS SOMETHING WRONG WITH THIS LOGIC lol
    transaction_amount = amount
    if payment_method.type == 'DebitAccount'
      transaction_amount *= -1 if type == 'Income'
    else
      transaction_amount *= -1 if type == 'Expense'
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
