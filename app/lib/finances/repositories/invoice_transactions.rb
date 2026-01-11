module Finances
  module Repositories
    class InvoiceTransactions
      class InvalidExpenseError < StandardError; end
      class NotImplementedError < StandardError; end

      ENTITY = Entities::InvoiceTransaction

      def create(params)
        raise NotImplementedError, "create method must be implement"
      end

      def find_all(filters)
        raise NotImplementedError, "find_all method must be implement"
      end

      def find_by(filters)
        raise NotImplementedError, "find_by method must be implement"
      end
    end
  end
end
