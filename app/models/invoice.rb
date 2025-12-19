class Invoice < Transaction
  include HasStatus

  has_many :invoice_items, class_name: "Expense", foreign_key: :invoice_id
end
