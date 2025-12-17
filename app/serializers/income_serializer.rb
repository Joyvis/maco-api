class IncomeSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date
end
