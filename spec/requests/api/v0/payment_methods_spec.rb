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
          # convert into a shared example
          expect(response).to have_http_status(:created)
          expect(DebitAccount.count).to eq(1)
          expect(parsed_response[:balance]).to eq(50)
          expect(Income.count).to eq(1)
          expect(income_transaction.amount).to eq(50)
          expect(income_transaction.description).to eq('Initial balance')
        end
      end

      context 'with invalid params' do
        let(:params) { { type: 'DebitAccount' } }

        it 'returns a unprocessable entity response' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_response[:errors]).to be_present
          expect(DebitAccount.count).to eq(0)
        end
      end
    end

    # context 'when payment method is CreditAccount' do
    # end
  end

  describe 'GET /api/v0/payment_methods' do
    before do
      create_list(:payment_method, 2)
      get '/api/v0/payment_methods'
    end

    it 'lists payment methods' do
      expect(response).to have_http_status(:success)
      expect(parsed_response).to be_a(Array)
      expect(parsed_response.size).to eq(2)
    end
  end

  describe 'PATCH /api/v0/payment_methods/:id' do
    let(:payment_method) { create(:payment_method) }

    before do
      patch "/api/v0/payment_methods/#{payment_method.id}",
        params: {
          payment_method: { name: 'Groceries' }
        }
    end

    it 'updates a payment method' do
      expect(response).to have_http_status(:success)
      expect(parsed_response[:name]).to eq('Groceries')
    end
  end

  describe 'DELETE /api/v0/payment_methods/:id' do
    let(:payment_method) { create(:payment_method) }

    before { delete "/api/v0/payment_methods/#{payment_method.id}" }

    it 'deletes a payment method' do
      expect(response).to have_http_status(:no_content)
      expect(DebitAccount.count).to eq(0)
    end
  end
end
