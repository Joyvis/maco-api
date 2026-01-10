module Finances
  module UseCases
    class CreateIncomeTransaction
      class RepositoryNotImplementedError < StandardError; end

      attr_reader :repository

      def initialize(repository:)
        unless repository.is_a? Finances::Repositories::IncomeTransactions
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
