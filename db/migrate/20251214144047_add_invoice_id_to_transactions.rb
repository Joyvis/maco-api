class AddInvoiceIdToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :invoice_id, :uuid
    add_foreign_key :transactions, :transactions, column: :invoice_id
    add_index :transactions, :invoice_id
  end
end
