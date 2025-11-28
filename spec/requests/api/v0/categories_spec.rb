require 'rails_helper'

RSpec.describe "Api::V0::Categories", type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  describe "GET /api/v0/categories" do
    before do
      create_list(:category, 3)
      get '/api/v0/categories'
    end

    it 'lists categories' do
      expect(response).to have_http_status(:success)
      expect(parsed_response).to be_a(Array)
      expect(parsed_response.size).to eq(3)
    end
  end

  describe "POST /api/v0/categories" do
    before do
      post '/api/v0/categories', params: { category: { name: 'Groceries' } }
    end

    it 'creates a category' do
      expect(response).to have_http_status(:created)
      expect(parsed_response[:name]).to eq('Groceries')
    end
  end

  describe "PATCH /api/v0/categories/:id" do
    let(:category) { create(:category) }

    before do
      patch "/api/v0/categories/#{category.id}", params: { category: { name: 'Groceries' } }
    end

    it 'updates a category' do
      expect(response).to have_http_status(:success)
      expect(parsed_response[:name]).to eq('Groceries')
    end
  end

  describe "DELETE /api/v0/categories/:id" do
    let(:category) { create(:category) }

    before do
      delete "/api/v0/categories/#{category.id}"
    end

    it 'deletes a category' do
      expect(response).to have_http_status(:no_content)
      expect(Category.count).to eq(0)
    end
  end
end
