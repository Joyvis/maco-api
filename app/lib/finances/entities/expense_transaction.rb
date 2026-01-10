module Finances
  module Entities
    class ExpenseTransaction < Transaction
      attr_accessor :category_id, :invoice_id
    end
  end
end
