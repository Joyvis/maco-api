class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :status
end
