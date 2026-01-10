module Transactions
  class InvalidIncomeError < StandardError; end

  class IncomesRepository < Finances::Repositories::IncomeTransactions
    def create(income_params)
      income = Income.create_transaction!(income_params)

      ENTITY.new(income.attributes)
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidIncomeError, e.full_message
    end
  end
end
