module Api::V0
  # TODO: break this controller into separate controllers for expenses and incomes
  class TransactionsController < ApplicationController
    def index
      transactions = Transaction.all
      render json: transactions
    end

    def create
      repo = TransactionsRepository.new(type: klass_model)
      transaction = TransactionCreator.new(repo: repo).call(params: transaction_params)

      render json: transaction, status: :created
    end

    def update
      transaction = Transaction.find(params[:id])
      transaction.update!(transaction_params)
      render json: transaction
    end

    def destroy
      # TODO: it should work for both expenses and incomes
      transaction = Transaction.find(params[:id])
      transaction.destroy!
      head :no_content
    end

    # TODO: rename to summary
    def monthly_summary
      transactions = Transaction.not_invoice_item
      # filter by paid_at
      paid_incomes = transactions.income.paid.ransack(params[:q]).result
      paid_expenses = transactions.not_income.paid.ransack(params[:q]).result

      # filter by due_date
      not_paid_incomes = transactions.income.not_paid
      not_paid_expenses = transactions.not_income.not_paid

      render json: {
        paid_total: paid_incomes.sum(:amount) - paid_expenses.sum(:amount),
        paid_transactions: serialized_resources(paid_incomes + paid_expenses),
        not_paid_total: not_paid_incomes.sum(:amount) - not_paid_expenses.sum(:amount),
        not_paid_transactions: serialized_resources(not_paid_incomes + not_paid_expenses)
      }, status: :ok
    end

    private

    def serialized_resources(resources)
      ActiveModelSerializers::SerializableResource.new(resources)
    end

    def klass_model
      params[:transaction][:type].downcase == "expense" ? Expense : Income
    end

    def transaction_params
      params
        .require(:transaction)
        .permit(
          :amount, :description, :category_id, :due_date, :payment_method_id, :paid_at
        )
    end
  end
end
