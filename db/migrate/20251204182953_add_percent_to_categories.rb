class AddPercentToCategories < ActiveRecord::Migration[8.0]
  def change
    # TODO: maybe it can create issues when summing up
    add_column :categories, :percent, :float, null: true
  end
end
