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
      repository: Transactions::IncomesRepository,
      use_case: Finances::UseCases::CreateIncomeTransaction,
      params: INCOME_PARAMS

    },
    expense_transaction: {
      repository: Transactions::IncomesRepository,
      use_case: Finances::UseCases::CreateIncomeTransaction,
      params: EXPENSE_PARAMS
    }
  }.freeze

  def index
    @transactions = Transactions::IncomesRepository.new.find_all
    @transactions += Transactions::ExpensesRepository.new.find_all
    render json: @transactions
  end

  def create
    transaction_type_key = params.keys.first.to_sym
    transaction_type = TYPE_MAP[transaction_type_key]
    raise InvalidTrasactionType, "Invalid transaction type" if transaction_type.nil?

    transaction = create_transactions(transaction_type, transaction_type_key)
    render json: transaction, status: :created
  end

  private

  def create_transactions(type, key)
    repo = type[:repository].new
    transaction_params = transaction_params(key, type[:params])
    type[:use_case].new(repository: repo).call(params: transaction_params)
  end

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def transaction_params(key, type_params)
    params.require(key).permit(type_params)
  end
end
