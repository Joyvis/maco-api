require 'rails_helper'

RSpec.describe TransactionsRepository do
  describe '#create' do
    subject(:repository) do
      described_class.new(type: transaction_type).create(transaction_params)
    end

    context 'with Expense transactions' do
      let(:transaction_type) { Expense }

      context 'with valid params' do
        let(:transaction_params) { attributes_for(:expense) }
        it 'returns an Expense' do
          expect(repository).to be_a(transaction_type)
        end
      end

      context 'with invalid params' do
        let(:transaction_params) { nil }

        it 'raises an exception' do
          expect { repository }.to raise_error(TransactionsRepository::InvalidTransactionError)
        end
      end
    end

    context 'with Income transactions' do
      let(:transaction_type) { Income }

      context 'with valid params' do
        let(:transaction_params) { attributes_for(:income) }

        it 'returns an Expense' do
          expect(repository).to be_a(transaction_type)
        end
      end

      context 'with invalid params' do
        let(:transaction_params) { nil }

        it 'raises an exception' do
          expect { repository }.to raise_error(TransactionsRepository::InvalidTransactionError)
        end
      end
    end
  end
end
