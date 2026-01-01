class IncomeSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :status, :type, :paid_at, :payment_method_id

  def status
    "paid"
  end

  def paid_at
    object.created_at
  end
end
