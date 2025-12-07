class AddPaymentMethodReferenceToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions,
      :payment_method, null: false, type: :uuid, default: PaymentMethod.first.id

    change_column_default :transactions,
      :payment_method_id, from: PaymentMethod.first.id, to: nil
  end
end
