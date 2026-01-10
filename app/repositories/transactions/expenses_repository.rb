module Transactions
  class InvalidExpenseError < StandardError; end

  class ExpensesRepository < Finances::Repositories::ExpenseTransactions
    def create(params)
      expense = Expense.create_transaction!(params)

      ENTITY.new(expense.attributes)
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidExpenseError, e.full_message
    end

    def find_all
      Expense.all.map { |expense| ENTITY.new(expense.attributes) }
    end
  end
end
