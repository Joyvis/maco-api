module Finances
  module UseCases
    class CreateExpenseTransaction < UseCase
      REPOSITORIES = {
        expense_transaction_repository: {
          interface: Finances::Repositories::ExpenseTransactions,
          message: "Invalid Expense Repository"
        },
        invoice_transaction_repository: {
          interface: Finances::Repositories::InvoiceTransactions,
          message: "Invalid Invoice Repository"
        },
        credit_account_payment_method_repository: {
          interface: Finances::Repositories::CreditAccountPaymentMethods,
          message: "Invalid Credit Account Repository"
        },
        transaction_category_repository: {
          interface: Finances::Repositories::TransactionCategories,
          message: "Invalid Category Repository"
        }
      }.freeze

      VALIDATOR = {
        class: Finances::Validators::ExpenseTransactions,
        entities: [ :payment_method_entity, :transaction_category_entity ]
      }

      attr_reader :expense_transaction_repository,
        :invoice_transaction_repository,
        :credit_account_payment_method_repository,
        :transaction_category_repository

      def call(params:)
        @params = params
        validator.validate!(params)
        payment_method = payment_method_entity
        if payment_method
          invoice = fetch_invoice(payment_method)
          invoice = create_invoice(payment_method, params) unless invoice

          params[:invoice_id] = invoice.id
        end

        expense_transaction_repository.create(params)
      end

      private

      def payment_method_entity
        @payment_method_entity ||= fetch_payment_method(@params[:payment_method_id])
      end

      def transaction_category_entity
        @transaction_category_entity ||= fetch_transaction_category(@params[:category_id])
      end

      def fetch_transaction_category(uuid)
        transaction_category_repository.find_by_id(uuid)
      rescue Repositories::TransactionCategories::NotFoundError
        nil
      end

      def fetch_payment_method(uuid)
        credit_account_payment_method_repository.find_by_id(uuid)
      rescue Repositories::CreditAccountPaymentMethods::NotFoundError
        nil
      end

      def fetch_invoice(payment_method)
        invoice_transaction_repository.find_by(
          description: payment_method.name + " Invoice",
          due_date: calculate_next_due_date(payment_method),
          payment_method_id: payment_method.id,
          paid_at: nil
        )
      rescue Repositories::InvoiceTransactions::NotFoundError
        nil
      end

      def create_invoice(payment_method, params)
        invoice_transaction_repository.create(
          description: payment_method.name + " Invoice",
          due_date: calculate_next_due_date(payment_method),
          payment_method_id: payment_method.id,
          amount: params[:amount]
        )
        # Rescue invalid params error defined in the repository interface
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
