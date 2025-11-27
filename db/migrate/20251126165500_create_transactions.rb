class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    # TODO: use UUIDs
    create_table :transactions do |t|
      t.decimal :amount, null: false
      t.string :type, null: false
      t.date :due_date, null: false
      t.text :description
      t.string :category_id, null: false

      t.timestamps
    end
  end
end
