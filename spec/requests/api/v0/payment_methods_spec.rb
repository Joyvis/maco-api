require 'rails_helper'

RSpec.describe "Api::V0::PaymentMethods", type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'POST /api/v0/payment_methods' do
    before do
      post '/api/v0/payment_methods', params: { payment_method: params }
    end

    context 'when payment method is DebitAccount' do
      context 'with valid params' do
        let(:params) do
          { name: 'test', type: 'DebitAccount', initial_balance: 50 }
        end
        let(:income_transaction) { Income.first }

        # consider negative balance - Expense transaction
        it 'creates a payment method' do
          expect(response).to have_http_status(:created)
          expect(DebitAccount.count).to eq(1)
          expect(parsed_response[:balance]).to eq(50)
          expect(Income.count).to eq(1)
          expect(income_transaction.amount).to eq(50)
          expect(income_transaction.description).to eq('Initial balance')
        end
      end
    end

    # context 'when payment method is CreditAccount' do
    # end
  end
end
