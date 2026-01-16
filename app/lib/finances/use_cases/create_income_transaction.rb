module Finances
  module UseCases
    class CreateIncomeTransaction < UseCase
      class RepositoryNotImplementedError < StandardError; end

      REPOSITORIES = {
        income_transaction_repository: {
          interface: Finances::Repositories::IncomeTransactions,
          message: "Invalid Income Repository"
        },
        payment_method_repository: {
          interface: Finances::Repositories::PaymentMethods,
          message: "Invalid Income Repository"
        }
      }.freeze

      VALIDATOR = {
        class: Finances::Validators::IncomeTransactions,
        entities: [ :payment_method_entity ]
      }

      attr_accessor :income_transaction_repository, :payment_method_repository

      def call(params:)
        @params = params
        validator.validate!(params)
        income_transaction_repository.create(params)
      end

      private

      def payment_method_entity
        @payment_method_entity ||= payment_method_repository.find_by_id(@params[:payment_method_id])
      end
    end
  end
end
