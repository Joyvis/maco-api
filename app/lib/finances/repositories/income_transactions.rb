module Finances
  module Repositories
    class IncomeTransactions
      class InvalidIncomeError < StandardError; end
      class NotImplementedError < StandardError; end

      ENTITY = Entities::IncomeTransaction

      def create
        raise NotImplementedError, 'create method must be implement'
      end

      def find_all
        raise NotImplementedError, 'find_all method must be implement'
      end
    end
  end
end
