require 'rails_helper'

RSpec.describe Transactions::ExpensesRepository do
  describe '#create' do
    subject(:expense_transaction) { described_class.new.create(expense_params) }

    context 'with valid params' do
      let(:expense_params) { attributes_for(:expense) }

      it 'creates a new income' do
        expect(expense_transaction).to be_a(Finances::Entities::ExpenseTransaction)
      end
    end

    context 'with invalid params' do
      let(:expense_params) { attributes_for(:expense, amount: nil) }

      it 'raises an error' do
        expect { expense_transaction }.to raise_error(Transactions::InvalidExpenseError)
      end
    end
  end
end
