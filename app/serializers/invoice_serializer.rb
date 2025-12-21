class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :due_date, :status, :type

  has_many :invoice_items
end
