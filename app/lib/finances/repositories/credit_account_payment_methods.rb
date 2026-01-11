module Finances
  module Repositories
    class CreditAccountPaymentMethods
      # TODO: Move to a parent class
      class InvalidExpenseError < StandardError; end
      class NotImplementedError < StandardError; end

      ENTITY = Entities::CreditAccountPaymentMethod

      def create(params)
        raise NotImplementedError, "create method must be implement"
      end

      def find_by_id(uuid)
        raise NotImplementedError, "find_by_id method must be implement"
      end

    end
  end
end
