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

      response '422', 'income transaction not created' do
        let(:income_transaction) do
          {
            income_transaction: attributes_for(:income, amount: nil)
          }
        end

        run_test!
      end
    end

    post 'Create Expense Transaction' do
      tags 'Expense Transactions'
      consumes 'application/json'
      parameter name: 'expense_transaction', in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string },
          amount: { type: :number },
          due_date: { type: :string },
          payment_method_id: { type: :string },
          category_id: { type: :string },
          paid_at: { type: :string }
        },
        required: [
          'description', 'amount', 'due_date', 'payment_method_id',
          'category_id'
        ]
      }

      response '201', 'expense transaction created' do
        let(:expense_transaction) do
          {
            expense_transaction: attributes_for(:expense)
          }
        end

        run_test!
      end

      response '422', 'expense transaction not created' do
        let(:expense_transaction) do
          {
            expense_transaction: attributes_for(:expense, amount: nil)
          }
        end

        run_test!
      end
    end

    post 'Create Unexpected Type Transaction' do
      tags 'Invalid Transaction Type'
      consumes 'application/json'
      parameter name: 'foo_transaction', in: :body, schema: {
        type: :object
      }
      response '400', 'invalid transaction error' do
        let(:foo_transaction) do
          {
            foo_transaction: nil
          }
        end

        run_test!
      end
    end

  end
end
