require 'rails_helper'

RSpec.describe Finances::UseCases::CreateExpenseTransaction do
  describe '#call' do
    class ExpenseRepo < Finances::Repositories::ExpenseTransactions; end
    class InvoiceRepo < Finances::Repositories::InvoiceTransactions; end
    class CreditAccountRepo < Finances::Repositories::CreditAccountPaymentMethods; end

    let(:expense_transaction_repo) { ExpenseRepo.new }
    let(:invoice_transaction_repo) { InvoiceRepo.new }
    let(:credit_account_payment_method_repo) { CreditAccountRepo.new }

    subject do
      described_class.
        new(
          expense_transaction_repository: expense_transaction_repo,
          credit_account_payment_method_repository: credit_account_payment_method_repo,
          invoice_transaction_repository: invoice_transaction_repo
        ).call(params: params)
    end

    # TODO: move this interface validation to the parent class
    context 'when repo implements the correct interface' do
      before do
        allow(credit_account_payment_method_repo).
          to receive(:find_by_id).and_return(credit_account_payment_method)

        allow(invoice_transaction_repo).
          to receive(:find_by).and_return(invoice_transaction)
      end

      let(:credit_account_payment_method) { build_stubbed(:credit_account_payment_method_entity) }
      let(:invoice_transaction) { build_stubbed(:invoice_transaction_entity) }

      let(:params) { attributes_for(:expense) }

      context 'when params are valid' do
        context 'when expense is associated to a credit account payment method' do
          before do
            allow(expense_transaction_repo).to receive(:create)
          end

          let(:expected_params) do
            params.merge(invoice_id: invoice_transaction.id)
          end

          context 'when there is an open invoice' do
            it 'finds the invoice and creates an expense transaction associated with' do
              expect { subject }.not_to raise_error

              expect(expense_transaction_repo).to have_received(:create).with(expected_params)
            end
          end

          context 'when there is no open invoice' do
            before do
              allow(invoice_transaction_repo).
                to receive(:create).and_return(invoice_transaction)

              allow(invoice_transaction_repo).
                to receive(:find_by).and_return(nil)
            end

            it 'opens an invoice and creates an expense transaction associated with' do
              expect { subject }.not_to raise_error
              expect(invoice_transaction_repo).to have_received(:create)

              expect(expense_transaction_repo).to have_received(:create).with(expected_params)
            end
          end
        end
      end

      context 'when params are invalid' do
        class MockedError < StandardError; end
        before { allow(expense_transaction_repo).to receive(:create).and_raise(MockedError) }

        it 'raises an error' do
          expect { subject }.to raise_error(MockedError)
        end
      end
    end

    context 'when repo does not implement the correct interface' do
      class WrongExpenseRepo; end
      let(:expense_transaction_repo) { WrongExpenseRepo.new }
      let(:params) { nil }

      it 'it raises an exception' do
        expect { subject }
          .to raise_error(
            ::UseCase::RepositoryNotImplementedError
          )
      end
    end
  end
end
