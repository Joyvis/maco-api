class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date
  attribute :status, if: -> { object.invoice_id.nil? }
end
