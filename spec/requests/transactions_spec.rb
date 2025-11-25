require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  describe 'POST /transactions' do
    before { post '/transactions', params: { transaction: params } }

    context 'with valid params' do
      let(:params) { { amount: 100 } }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

  end
end
