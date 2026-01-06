class Api::V1::TransactionsController < ApplicationController
  class InvalidTrasactionType < StandardError; end

  rescue_from InvalidTrasactionType, with: :bad_request

  TYPE_MAP = {
    income_transaction: Income,
    expense_transaction: Expense
  }.freeze

  def index
    @transactions = Transaction.all
    render json: @transactions
  end

  def create
    transaction_type = TYPE_MAP[params.keys.first.to_sym]
    raise InvalidTrasactionType, "Invalid transaction type" if transaction_type.nil?

    transaction = create_transaction
    render json: transaction, status: :created
  end

  private

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def create_transaction
    return create_income if params[:income_transaction].present?

    return create_expense if params[:expense_transaction].present?

    raise "Invalid transaction type"
  end

  def create_income
    Income.create!(income_transaction_params)
  end

  def create_expense
    Expense.create!(expense_transaction_params)
  end

  def income_transaction_params
    params.
      require(:income_transaction).
      permit(:description, :amount, :due_date, :payment_method_id)
  end

  def expense_transaction_params
    params.
      require(:expense_transaction).
      permit(
        :description, :amount, :due_date, :payment_method_id, :category_id,
        :paid_at
      )
  end
end
