module Api::V0
  class TransactionsController < ApplicationController
    def index
      render json: Transaction.all
    end

    def create
      transaction = klass_model.create!(transaction_params)
      render json: transaction, status: :created
    end

    private

    def klass_model
      params[:transaction][:type] == 'expense' ? Expense : Income
    end

    def transaction_params
      params
        .require(:transaction)
        .permit(
          :amount, :description, :category_id, :due_date,
        )
    end
  end
end
