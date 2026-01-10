module Finances
  module UseCases
    class CreateExpenseTransaction < UseCase
      REPOSITORIES = {
        repository: {
          interface: Finances::Repositories::ExpenseTransactions,
          message: 'Invalid Expense Repository'
        },
        invoice_repository: {
          interface: Finances::Repositories::InvoiceTransactions,
          message: 'Invalid Invoice Repository'
        }
      }.freeze

      attr_reader :repository, :invoice_repository

      def initialize(repository:, invoice_repository: nil)
        super

        @repository = repository
        @invoice_repository = invoice_repository
      end

      def call(params:)
        # TODO: inject payment method repo
        repository.create(params)
      end

    end
  end
end
