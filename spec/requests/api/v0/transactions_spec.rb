require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'POST /api/v0/transactions' do
    before { post '/api/v0/transactions', params: { transaction: params } }

    context 'with valid params' do
      let(:params) { attributes_for(:expense) }

      it 'returns http success' do
        expect(response).to have_http_status(:created)
        expect(Transaction.count).to eq(1)
      end
    end
  end

  describe 'GET /api/v0/transactions' do
    before do
      create_list(:expense, 3)
      get '/api/v0/transactions'
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
      expect(parsed_response).to be_a(Array)
      expect(parsed_response.count).to eq(3)
    end
  end

  describe 'DELETE /api/v0/transactions/:id' do
    let(:transaction) { create(:transaction) }
    let(:transaction) do
      create(:income)
    end

    before { delete "/api/v0/transactions/#{transaction.id}" }

    it 'deletes the transaction' do
      expect(response).to have_http_status(:no_content)
      expect(Transaction.count).to eq(0)
    end
  end

  describe 'PATCH /api/v0/transactions/:id' do
    let(:transaction) { create(:income) }

    before { patch "/api/v0/transactions/#{transaction.id}", params: { transaction: { amount: 200 } } }

    it 'updates the transaction' do
      expect(response).to have_http_status(:success)
      expect(parsed_response[:amount]).to eq '200.0'
    end
  end
end
