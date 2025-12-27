class AddPaymentMethodReferenceToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions,
      :payment_method, null: false, type: :uuid
  end
end
