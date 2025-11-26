require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  describe 'POST /transactions' do
    before { post '/transactions', params: { transaction: params } }

    context 'with valid params' do
      let(:params) do
        {
          amount: 100,
          transaction_type: 'expense',
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
end
