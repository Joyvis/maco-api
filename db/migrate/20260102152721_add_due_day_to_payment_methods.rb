class AddDueDayToPaymentMethods < ActiveRecord::Migration[8.0]
  def change
    add_column :payment_methods, :due_day, :integer, null: true
  end
end
