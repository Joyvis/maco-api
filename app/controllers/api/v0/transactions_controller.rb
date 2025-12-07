module Api::V0
  # TODO: break this controller into separate controllers for expenses and incomes
  class TransactionsController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessible_entity

    def index
      transactions = Transaction.includes(:category).all
      render json: transactions, each_serializer: ::TransactionSerializer
    end

    def create
      transaction = nil
      ActiveRecord::Base.transaction do
        transaction = klass_model.create!(transaction_params)
        transaction.payment_method.update!(
          balance: transaction.payment_method.balance - transaction.amount
        )
      end

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

    private

    def render_unprocessible_entity(invalid)
      render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

    def klass_model
      params[:transaction][:type] == 'expense' ? Expense : Income
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
