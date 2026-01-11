module Finances
  module UseCases
    class CreateExpenseTransaction < UseCase
      REPOSITORIES = {
        expense_transaction_repository: {
          interface: Finances::Repositories::ExpenseTransactions,
          message: 'Invalid Expense Repository'
        },
        invoice_transaction_repository: {
          interface: Finances::Repositories::InvoiceTransactions,
          message: 'Invalid Invoice Repository'
        },
        credit_account_payment_method_repository: {
          interface: Finances::Repositories::CreditAccountPaymentMethods,
          message: 'Invalid Invoice Repositoryk'
        }
      }.freeze

      attr_reader :expense_transaction_repository,
        :invoice_transaction_repository,
        :credit_account_payment_method_repository

      def call(params:)
        # TODO: inject payment method repo
        # if the payment method type is equals to CreditAccount
        # Then create an invoice.
        payment_method = credit_account_payment_method_repository.
          find_by_id(params[:payment_method_id])

        if payment_method
          invoice = fetch_invoice(payment_method)
          invoice = create_invoice(payment_method, params) unless invoice

          params[:invoice_id] = invoice.id
        end

        expense_transaction_repository.create(params)
      end

      private

      def fetch_invoice(payment_method)
        invoice_transaction_repository.find_by(
          description: payment_method.name + " Invoice",
          due_date: calculate_next_due_date(payment_method),
          payment_method_id: payment_method.id,
          paid_at: nil
        )
      end

      def create_invoice(payment_method, params)
        invoice_transaction_repository.create(
          description: payment_method.name + " Invoice",
          due_date: calculate_next_due_date(payment_method),
          payment_method_id: payment_method.id,
          amount: params[:amount]
        )
      end

      def calculate_next_due_date(payment_method)
        next_month = Date.today
        next_month = next_month.next_month if next_month.day > payment_method.due_day

        next_month = next_month.beginning_of_month
        next_month + (payment_method.due_day - 1).days
      end
    end
  end
end
