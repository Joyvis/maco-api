require 'swagger_helper'

RSpec.describe 'Transactions API V1', type: :request do
  path '/api/v1/transactions' do
    get 'List Transactions' do
      tags 'Transactions'
      produces 'application/json'

      response '200', 'Transactions found' do
        let(:transactions) { create_list(:transaction, 2) }
        run_test!
      end
    end
  end
end
