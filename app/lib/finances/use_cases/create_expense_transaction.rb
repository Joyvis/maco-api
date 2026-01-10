module Finances
  module UseCases
    class CreateExpenseTransaction
      class RepositoryNotImplementedError < StandardError; end

      attr_reader :repository

      def initialize(repository:)
        unless repository.is_a? Finances::Repositories::ExpenseTransactions
          raise RepositoryNotImplementedError
        end

        @repository = repository
      end

      def call(params:)
        repository.create(params)
      end
    end
  end
end
