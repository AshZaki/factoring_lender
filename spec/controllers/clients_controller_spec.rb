require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let(:valid_client) { create(:client) }
  let(:invalid_client) { build(:client, name: nil) }
  
  describe 'GET #index' do
    before do
      valid_client
    end

    it 'returns all clients with invoices' do
      get :index, format: :json
      clients = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(clients.map { |client| client['id'] }).to include(valid_client.id)
    end
  end


  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new client' do
        expect {
          post :create, params: { client: attributes_for(:client) }, format: :json
        }.to change(Client, :count).by(1)
      end

      it 'returns a :created status' do
        post :create, params: { client: attributes_for(:client) }, format: :json
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the requested client' do
        put :update, params: { id: valid_client.id, client: { name: 'New Name' } }, format: :json
        valid_client.reload
        expect(valid_client.name).to eq('New Name')
      end

      it 'returns a :ok status' do
        put :update, params: { id: valid_client.id, client: { name: 'New Name' } }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the requested client' do
        put :update, params: { id: valid_client.id, client: { name: nil } }, format: :json
        valid_client.reload
        expect(valid_client.name).not_to be_nil
      end

    end
  end
end
