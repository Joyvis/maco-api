class Api::V1::TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
    render json: @transactions
  end

  def create
    income = Income.create!(income_transaction_params)
    render json: income, status: :created
  end

  private

  def income_transaction_params
    params.
      require(:income_transaction).
      permit(:description, :amount, :due_date, :payment_method_id)
  end
end
