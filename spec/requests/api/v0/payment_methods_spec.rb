require 'rails_helper'

RSpec.describe "Api::V0::PaymentMethods", type: :request do
  describe 'POST /api/v0/payment_methods' do
    before do
      post '/api/v0/payment_methods', params: { payment_method: params }
    end

    context 'when payment method is DebitAccount' do
      context 'with valid params' do
        let(:params) do
          { name: 'test', type: 'DebitAccount', initial_balance: 50 }
        end

        # consider negative balance - Expense transaction
        it 'creates a payment method' do
          expect(response).to have_http_status(:created)
          expect(DebitAccount.count).to eq(1)
          # expect(Income.count).to eq(1)
        end
      end
    end

    # context 'when payment method is CreditAccount' do
    # end
  end
end
