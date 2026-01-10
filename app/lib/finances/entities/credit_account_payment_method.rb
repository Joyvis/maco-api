module Finances
  module Entities
    class CreditAccountPaymentMethod < PaymentMethod
      attr_accessor :due_day
    end
  end
end
