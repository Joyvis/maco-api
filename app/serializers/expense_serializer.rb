class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :category_name, :type,
    :paid_at, :payment_method_name

  attribute :status, if: -> { object.invoice_id.nil? }

  def category_name
    object.category.name
  end

  def payment_method_name
    object.payment_method.name
  end
end
