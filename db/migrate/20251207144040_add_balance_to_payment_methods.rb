class AddBalanceToPaymentMethods < ActiveRecord::Migration[8.0]
  def change
    add_column :payment_methods, :balance, :float, null: false
  end
end
