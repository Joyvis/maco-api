class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :status, :type, :paid_at

  has_many :invoice_items
end
