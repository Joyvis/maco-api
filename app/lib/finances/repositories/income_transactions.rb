module Finances
  module Repositories
    class IncomeTransactions
      class InvalidIncomeError < StandardError; end
      class NotImplementedError < StandardError; end

      def create(params)
        raise NotImplementedError, 'create method must be implement'
      end

      def entity = Entities::IncomeTransaction
    end
  end
end
