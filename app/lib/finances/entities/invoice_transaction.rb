module Finances
  module Entities
    class InvoiceTransaction < Transaction
      attr_accessor :items
    end
  end
end
