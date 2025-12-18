module Api::V0
  # TODO: break this controller into separate controllers for expenses and incomes
  class TransactionsController < ApplicationController
    def index
      transactions = Transaction.includes(:category).all
      render json: transactions, each_serializer: ::TransactionSerializer
    end

    def create
      transaction = klass_model.create!(transaction_params)
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

    def monthly_summary
      render json: {}, status: :ok
    end

    private

    def klass_model
      params[:transaction][:type] == 'Expense' ? Expense : Income
    end

    def transaction_params
      params
        .require(:transaction)
        .permit(
          :amount, :description, :category_id, :due_date, :payment_method_id
        )
    end
  end
end
