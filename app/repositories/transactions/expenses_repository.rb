module Transactions
  class InvalidExpenseError < StandardError; end

  class ExpensesRepository < Finances::Repositories::ExpenseTransactions
    def create(params)
      expense = Expense.new(params)
      expense.save!(validate: false)

      ENTITY.new(expense.attributes)
    rescue ActiveRecord::NotNullViolation => e
      raise InvalidExpenseError, e.full_message
    end

    def find_all
      Expense.all.map { |expense| ENTITY.new(expense.attributes) }
    end
  end
end
