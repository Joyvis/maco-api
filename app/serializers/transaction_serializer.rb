class TransactionSerializer < ActiveModel::Serializer
  # belongs_to :category

  attributes :id, :amount, :description, :due_date, :category_name, :type

  def category_name
    object.category.name if object.type == 'Expense'
  end
end
