require 'rails_helper'

RSpec.describe "Api::V0::PaymentMethods::Invoices", type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'POST /api/v0/payment_methods/:id/invoices' do
    before do
      post "/api/v0/payment_methods/#{payment_method.id}/invoices/",
        params: { payment_method_invoice: params }
    end

    context 'when payment method is DebitAccount' do
      let(:params) { { due_date: Date.today } }

      let(:payment_method) { create(:debit_account) }

      it 'returns an error response' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when payment method is CreditAccount' do
      let(:payment_method) { create(:credit_account, :with_expenses) }

      context 'with valid params' do
        let(:params) { { due_date: Date.today, amount: 2 } }

        it 'creates an invoice' do
          expect(response).to have_http_status(:created)
          total_amount = parsed_response[:invoice_items].sum { |t| t[:amount].to_f }
          expect(parsed_response[:id]).to be_present
          expect(parsed_response[:amount].to_f).to eq(total_amount)
          expect(parsed_response[:invoice_items].size).to eq(2)
        end
      end

      context 'with invalid params' do
        let(:params) { { due_date: Date.today, amount: 3 } }

        it 'returns an error response' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
