require 'rails_helper'

RSpec.describe Finances::UseCases::CreateIncomeTransaction do
  describe '#call' do
    context 'when repo implements the correct interface' do
      class IncomeRepo < Finances::Repositories::IncomeTransactions; end

      let(:repo) { IncomeRepo.new }
      let(:params) { { amount: 100 } }
      let(:validator) { instance_double(Finances::Validators::IncomeTransactions, validate!: nil)}
      subject do
        # TODO: payment_method_repo must be required
        described_class.
          new(
            repositories: {
              income_transaction_repository: repo
            },
            validator: validator
          ).
          call(params: params)
      end

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
        before { allow(validator).to receive(:validate!).and_raise(MockedError) }

        it 'raises an error' do
          expect { subject }.to raise_error(MockedError)
        end
      end
    end

    context 'when repo does not implement the correct interface' do
      class WrongIncomeRepo; end
      let(:repo) { WrongIncomeRepo.new }
      subject do
        described_class.
          new(
            repositories: {
              income_transactions_repository: repo
            }
          ).
          call(params: nil)
      end

      it 'it raises an exception' do
        expect { subject }
          .to raise_error(
            UseCase::RepositoryNotImplementedError
          )
      end
    end
  end
end
