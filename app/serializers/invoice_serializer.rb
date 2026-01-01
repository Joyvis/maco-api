class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :status, :type, :paid_at,
    :payment_method_name, :payment_method_id

  has_many :invoice_items

  def payment_method_name
    object.payment_method.name
  end
end
