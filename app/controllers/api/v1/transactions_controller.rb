class Api::V1::TransactionsController < ApplicationController
  class InvalidTrasactionType < StandardError; end

  rescue_from InvalidTrasactionType, with: :bad_request

  INCOME_PARAMS = [
    :description, :amount, :due_date, :payment_method_id
  ].freeze

  EXPENSE_PARAMS = INCOME_PARAMS + [
    :category_id, :paid_at
  ].freeze

  TYPE_MAP = {
    income_transaction: {
      type: Income,
      params: INCOME_PARAMS
    },
    expense_transaction: {
      type: Expense,
      params: EXPENSE_PARAMS
    }
  }.freeze

  def index
    @transactions = Transaction.all
    render json: @transactions
  end

  def create
    transaction_type_key = params.keys.first.to_sym
    transaction_type = TYPE_MAP[transaction_type_key]&.fetch(:type, nil)
    raise InvalidTrasactionType, "Invalid transaction type" if transaction_type.nil?

    if transaction_type == Income
      transaction = create_income(transaction_type_key)
    else
      transaction = create_transactions(transaction_type_key, transaction_type)
    end

    render json: transaction, status: :created
  end

  private

  def create_income(transaction_type_key)
    repo = Transactions::IncomesRepository.new
    transaction_params = transaction_params(
      type: transaction_type_key,
      type_params: TYPE_MAP[transaction_type_key][:params]
    )

    Finances::UseCases::CreateIncomeTransaction.
      new(repository: repo).
      call(params: transaction_params)
  end

  def create_transactions(transaction_type_key, transaction_type)
    repo = TransactionsRepository.new(type: transaction_type)
    transaction_params = transaction_params(
      type: transaction_type_key,
      type_params: TYPE_MAP[transaction_type_key][:params]
    )

    TransactionCreator.
      new(repo: repo).
      call(params: transaction_params)
  end

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def transaction_params(type:, type_params:)
    params.require(type).permit(type_params)
  end
end
