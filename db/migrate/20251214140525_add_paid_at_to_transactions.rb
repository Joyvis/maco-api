class AddPaidAtToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :paid_at, :datetime, null: true
  end
end
