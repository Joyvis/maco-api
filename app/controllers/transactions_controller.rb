class TransactionsController < ApplicationController
  def create
    transaction = Transaction.create!(transaction_params)
    render json: transaction, status: :created
  end

  private

  def transaction_params
    params
      .require(:transaction)
      .permit(
        :amount, :description, :title, :transaction_type, :category_id, :due_date,
      )
  end
end
