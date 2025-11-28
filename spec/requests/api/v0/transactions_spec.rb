require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }
  describe 'POST /api/v0/transactions' do
    before { post '/api/v0/transactions', params: { transaction: params } }

    context 'with valid params' do
      let(:params) do
        {
          amount: 100,
          type: 'expense',
          due_date: Date.today,
          title: 'Groceries',
          description: 'Groceries for the week',
          category_id: 'groceries',
        }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
        expect(Transaction.count).to eq(1)
      end
    end
  end

  describe 'GET /api/v0/transactions' do
    before { get '/api/v0/transactions' }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
      expect(parsed_response).to be_a(Array)
    end
  end

  describe 'DELETE /api/v0/transactions/:id' do
    let(:transaction) { create(:transaction) }
    let(:transaction) do
      Expense.create!(
        {
          amount: 100,
          due_date: Date.today,
          description: 'Groceries for the week',
          category_id: 'groceries',
        }
      )
    end

    before { delete "/api/v0/transactions/#{transaction.id}" }

    it 'deletes the transaction' do
      expect(response).to have_http_status(:no_content)
      expect(Transaction.count).to eq(0)
    end
  end

  describe 'PATCH /api/v0/transactions/:id' do
    let(:transaction) do
      Expense.create!(
        {
          amount: 100,
          due_date: Date.today,
          description: 'Groceries for the week',
          category_id: 'groceries',
        }
      )
    end

    before { patch "/api/v0/transactions/#{transaction.id}", params: { transaction: { amount: 200 } } }

    it 'updates the transaction' do
      expect(response).to have_http_status(:success)
      expect(parsed_response[:amount]).to eq '200.0'
    end
  end
end
