require 'rails_helper'

RSpec.describe Finances::UseCases::CreateExpenseTransaction do
  describe '#call' do
    context 'when repo implements the correct interface' do
      class ExpenseRepo < Finances::Repositories::ExpenseTransactions; end

      let(:repo) { ExpenseRepo.new }
      let(:params) { { amount: 100 } }
      subject { described_class.new(repository: repo).call(params: params) }

      context 'when params are valid' do
        before { allow(repo).to receive(:create).and_return(transaction) }
        let(:transaction) { double(:transaction) }

        it 'creates a transaction' do
          is_expected.to eq(transaction)
          expect(repo).to have_received(:create).with(params)
        end
      end

      context 'when params are invalid' do
        class MockedError < StandardError; end
        before { allow(repo).to receive(:create).and_raise(MockedError) }

        it 'raises an error' do
          expect { subject }.to raise_error(MockedError)
        end
      end
    end

    context 'when repo does not implement the correct interface' do
      class WrongExpenseRepo; end
      let(:repo) { WrongExpenseRepo.new }
      subject { described_class.new(repository: repo).call(params: nil) }

      it 'it raises an exception' do
        expect { subject }
          .to raise_error(
            ::UseCase::RepositoryNotImplementedError
          )
      end
    end
  end
end
