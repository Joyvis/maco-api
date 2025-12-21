class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :category_name, :type
  attribute :status, if: -> { object.invoice_id.nil? }

  def category_name
    object.category.name if object.type == "Expense"
  end
end
