require 'rails_helper'

RSpec.describe Transactions::IncomeCreator do
  describe '#call' do
    let(:params) { { amount: 100 } }
    subject { described_class.new(repository: repo).call(params: params) }

    context 'when params are valid' do
      let(:repo) { double(:repo, create: transaction) }
      let(:transaction) { double(:transaction) }

      it 'creates a transaction' do
        expect(subject).to eq(transaction)
        expect(repo).to have_received(:create).with(params)
      end
    end

    context 'when params are invalid' do
      class MockedError < StandardError; end
      before { allow(repo).to receive(:create).and_raise(MockedError) }
      let(:repo) { double(:repo, create: nil) }

      it 'raises an error' do
        expect { subject }.to raise_error(MockedError)
      end
    end
  end
end
