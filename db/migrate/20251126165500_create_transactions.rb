class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :transactions, id: :uuid do |t|
      t.decimal :amount, null: false
      t.string :type, null: false
      t.date :due_date, null: false
      t.text :description
      t.references :category, null: true, type: :uuid, foreign_key: false

      t.timestamps
    end
  end
end
