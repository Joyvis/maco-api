class TransactionsRepository
  class InvalidTransactionError < StandardError; end

  attr_reader :type

  def initialize(type:)
    @type = type
  end

  def create(transaction_params)
    type.create_transaction!(transaction_params)
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidTransactionError, e.full_message
  end
end
