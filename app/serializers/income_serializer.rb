class IncomeSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :status, :type, :paid_at, :payment_method_id
end
