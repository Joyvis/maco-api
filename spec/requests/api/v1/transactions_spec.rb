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

    post 'Create Income Transaction' do
      tags 'Income Transactions'
      consumes 'application/json'
      parameter name: 'income_transaction', in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string },
          amount: { type: :number },
          due_date: { type: :string },
          payment_method_id: { type: :string }
        },
        required: [ 'description', 'amount', 'due_date', 'payment_method_id' ]
      }

      response '201', 'income transaction created' do
        let(:income_transaction) do
          {
            income_transaction: attributes_for(:income)
          }
        end

        run_test!
      end
    end
  end
end
