module Finances
  module UseCases
    class CreateIncomeTransaction < UseCase
      class RepositoryNotImplementedError < StandardError; end

      REPOSITORIES = {
        income_transaction_repository: {
          interface: Finances::Repositories::IncomeTransactions,
          message: "Invalid Income Repository"
        }
      }.freeze

      # VALIDATOR = {
      #   interface:
      # }.freeze

      attr_accessor :income_transaction_repository

      def call(params:)
        income_transaction_repository.create(params)
      end
    end
  end
end
