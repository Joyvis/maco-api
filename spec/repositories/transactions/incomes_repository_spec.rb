require 'rails_helper'

RSpec.describe Transactions::IncomesRepository do
  describe '#create' do
    subject(:income_transaction) { described_class.new.create(income_params) }

    context 'with valid params' do
      let(:income_params) { attributes_for(:income) }

      it 'creates a new income' do
        expect(income_transaction).to be_a(Finances::Entities::IncomeTransaction)
      end
    end

    context 'with invalid params' do
      let(:income_params) { attributes_for(:income, amount: nil) }

      it 'raises an error' do
        expect { income_transaction }.to raise_error(Transactions::InvalidIncomeError)
      end
    end
  end
end
