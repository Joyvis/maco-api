module Finances
  module Repositories
    class ExpenseTransactions
      class InvalidExpenseError < StandardError; end
      class NotImplementedError < StandardError; end

      ENTITY = Entities::ExpenseTransaction

      def create(params)
        raise NotImplementedError, "create method must be implement"
      end

      def find_all(filters)
        raise NotImplementedError, "find_all method must be implement"
      end
    end
  end
end
