require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'POST /api/v0/transactions' do
    describe "validating transactions for DebitAccount" do
      let(:payment_method_type) { :debit_account }
      let(:amount) { 5 }

      before { post '/api/v0/transactions', params: { transaction: params } }

      context 'with expense transactions' do
        let(:params) { attributes_for(:expense, amount: amount, payment_method_id: payment_method.id) }

        context 'with valid params' do
          # TODO: move this scenarios to the proper place
          context 'when payment method has balance' do
            let(:payment_method) { create(payment_method_type, balance: 100) }

            it 'returns http success' do
              expect(response).to have_http_status(:created)
              expect(Transaction.count).to eq(2)
              expect(PaymentMethod.find(payment_method.id).balance).to eq(95)
            end
          end

          context 'when payment method has no balance' do
            let(:payment_method) { create(payment_method_type, balance: 0) }

            it 'returns a unprocessable entity response' do
              expect(response).to have_http_status(:unprocessable_entity)
              expect(parsed_response[:errors]).to be_present
              expect(Transaction.count).to eq(0)
            end
          end
        end
      end

      context 'with income transactions' do
        let(:params) { attributes_for(:income, amount: amount, payment_method_id: payment_method.id) }

        context 'with valid params' do
          context 'when payment method has balance' do
            let(:payment_method) { create(payment_method_type, balance: 90) }

            it 'creates transaction and increments account balance' do
              expect(response).to have_http_status(:created)
              expect(Transaction.count).to eq(1)
              expect(PaymentMethod.find(payment_method.id).balance).to eq(95)
            end
          end

          context 'when payment method has no balance' do
            let(:payment_method) { create(payment_method_type, balance: 0) }

            it 'creates transaction and increments account balance' do
              expect(response).to have_http_status(:created)
              expect(Transaction.count).to eq(1)
              expect(PaymentMethod.find(payment_method.id).balance).to eq(5)
            end
          end
        end
      end
    end

    describe "validating transactions for CreditAccount" do
      let(:payment_method_type) { :credit_account }
      let(:amount) { 5 }

      before { post '/api/v0/transactions', params: { transaction: params } }

      context 'with expense transactions' do
        let(:params) { attributes_for(:expense, amount: amount, payment_method_id: payment_method.id) }

        context 'with valid params' do
          # TODO: move this scenarios to the proper place
          context 'when payment method has balance' do
            let(:payment_method) { create(payment_method_type, balance: 100) }

            it 'returns http success' do
              expect(response).to have_http_status(:created)
              expect(Transaction.count).to eq(1)
              expect(PaymentMethod.find(payment_method.id).balance).to eq(105)
            end
          end

          context 'when payment method has no balance' do
            let(:payment_method) { create(payment_method_type, balance: 0) }
            let(:amount) { 105 }

            it 'returns a unprocessable entity response' do
              expect(response).to have_http_status(:created)
              expect(Transaction.count).to eq(1)
              expect(PaymentMethod.find(payment_method.id).balance).to eq(105)
            end
          end
        end
      end

      context 'with income transactions' do
        let(:params) { attributes_for(:income, amount: amount, payment_method_id: payment_method.id) }

        context 'with valid params' do
          context 'when payment method has balance' do
            let(:payment_method) { create(payment_method_type, balance: 90) }

            it 'creates transaction and increments account balance' do
              expect(response).to have_http_status(:created)
              expect(Transaction.count).to eq(1)
              expect(PaymentMethod.find(payment_method.id).balance).to eq(85)
            end
          end

          context 'when payment method has no balance' do
            let(:payment_method) { create(payment_method_type, balance: 0) }

            it 'creates transaction and increments account balance' do
              expect(response).to have_http_status(:created)
              expect(Transaction.count).to eq(1)
              expect(PaymentMethod.find(payment_method.id).balance).to eq(-5)
            end
          end
        end
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

  describe 'GET /api/v0/transactions/monthly_summary' do
    let(:query_params) { '' }

    before do
      transactions

      get "/api/v0/transactions/monthly_summary#{query_params}"
    end

    RSpec.shared_examples 'monthly_summary_response' do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
        expect(parsed_response.keys).to contain_exactly(:total, :transactions)
        expect(parsed_response[:total].to_f).to be_a(Float)
        expect(parsed_response[:transactions]).to be_a(Array)
      end
    end

    context 'when transactions exist' do
      context 'with only expense transactions' do
        let(:transactions) { create_list(:expense, 3, amount: 1) }

        include_examples "monthly_summary_response"

        it 'returns http success' do
          expect(parsed_response[:total].to_f).to eq(-3.0)
          expect(parsed_response[:transactions].count).to eq(3)
        end
      end

      context 'with only income transactions' do
        let(:transactions) { create_list(:income, 3, amount: 1) }

        include_examples "monthly_summary_response"

        it 'returns http success' do
          expect(parsed_response[:total].to_f).to eq(3.0)
          expect(parsed_response[:transactions].count).to eq(3)
        end
      end

      context 'with only invoice transactions' do
        let(:transactions) { create_list(:invoice, 3, :invoice_items, amount: 1) }

        include_examples "monthly_summary_response"

        it 'returns http success' do
          expect(parsed_response[:total].to_f).to eq(-3.0)
          expect(parsed_response[:transactions].count).to eq(3)
          expect(parsed_response[:transactions].first[:invoice_items].count).to eq(2)
        end
      end

      context 'with all kind of transactions' do
        let(:transactions) do
          create_list(:expense, 3, amount: 1) +
            create_list(:income, 7, amount: 1) +
            create_list(:invoice, 3, :invoice_items, amount: 1)
        end

        include_examples "monthly_summary_response"

        it 'returns http success' do
          expect(parsed_response[:total].to_f).to eq(1.0)
          expect(parsed_response[:transactions].count).to eq(13)
        end
      end

      context 'when filtering data' do
        let(:query_params) { "?month=#{Date.today.month}" }

        let(:transactions) do
          create_list(:income, 3, amount: 1, due_date: Date.today-1.month)
          create_list(:expense, 3, amount: 1, due_date: Date.today-1.month)
          create_list(:income, 3, amount: 1)
          create_list(:expense, 3, amount: 1)
        end

        include_examples "monthly_summary_response"

        it 'returns filtered data' do
          expect(parsed_response[:total].to_f).to eq(0.0)
          expect(parsed_response[:transactions].count).to eq(6)
        end
      end
    end
  end
end
