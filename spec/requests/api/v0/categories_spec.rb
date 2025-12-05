require 'rails_helper'

RSpec.describe "Api::V0::transaction_categories", type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  describe "GET /api/v0/transaction_categories" do
    let(:query_string) { '' }

    before do
      create_list(:category, 2)
      create(:category, name: 'Filtered')
      get "/api/v0/transaction_categories#{query_string}"
    end

    context 'with name filter' do
      let(:query_string) { '?name=fil' }

      it 'filters transaction_categories' do
        expect(response).to have_http_status(:success)
        expect(parsed_response).to be_a(Array)
        expect(parsed_response.size).to eq(1)
      end
    end

    context 'without name filter' do
      it 'lists transaction_categories' do
        expect(response).to have_http_status(:success)
        expect(parsed_response).to be_a(Array)
        expect(parsed_response.size).to eq(3)
      end
    end
  end

  describe "POST /api/v0/transaction_categories" do
    before do
      post '/api/v0/transaction_categories',
        params: {
          transaction_category: { name: 'Groceries' }
        }
    end

    it 'creates a category' do
      expect(response).to have_http_status(:created)
      expect(parsed_response[:name]).to eq('Groceries')
    end
  end

  describe "PATCH /api/v0/transaction_categories/:id" do
    let(:category) { create(:category) }

    before do
      patch "/api/v0/transaction_categories/#{category.id}",
        params: {
          transaction_category: { name: 'Groceries' }
        }
    end

    it 'updates a category' do
      expect(response).to have_http_status(:success)
      expect(parsed_response[:name]).to eq('Groceries')
    end
  end

  describe "DELETE /api/v0/transaction_categories/:id" do
    let(:category) { create(:category) }

    before do
      delete "/api/v0/transaction_categories/#{category.id}"
    end

    it 'deletes a category' do
      expect(response).to have_http_status(:no_content)
      expect(Category.count).to eq(0)
    end
  end
end
