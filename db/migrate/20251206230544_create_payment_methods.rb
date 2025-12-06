class CreatePaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_methods, id: :uuid do |t|
      t.string :name, null: false
      t.string :type, null: false

      t.timestamps
    end
  end
end
