module Transactions
  class InvalidIncomeError < StandardError; end

  class IncomesRepository < Finances::Repositories::IncomeTransactions
    def create(income_params)
      income = Income.new(income_params)
      income.save!(validate: false)

      ENTITY.new(income.attributes)
    rescue ActiveRecord::NotNullViolation => e
      raise InvalidIncomeError, e.full_message
    end

    def find_all
      Income.all.map { |income| ENTITY.new(income.attributes) }
    end
  end
end
