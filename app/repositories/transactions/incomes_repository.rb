module Transactions
  class InvalidIncomeError < StandardError; end

  # TODO: move to business rules domain
  class IncomeTransactionEntity
    attr_accessor :id, :description, :amount, :due_date, :paid_at, :payment_method_id

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end

  class IncomesRepository
    def create(income_params)
      income = Income.create_transaction!(income_params)

      IncomeTransactionEntity.new(income.attributes)
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidIncomeError, e.full_message
    end
  end
end
