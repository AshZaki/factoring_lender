require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  let(:client) { create(:client) }
  let(:invoice) { create(:invoice, client: client) }
  
  before do
    create(:invoice, client: client)
  end

  describe 'GET #index' do
    let!(:invoice) { create(:invoice, client: client) }
    it 'returns all invoices' do
      get :index, format: :json
    invoices = JSON.parse(response.body)
    expect(response).to have_http_status(:success)
    expect(invoices.map { |invoice| invoice['id'] }).to include(invoice.id)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new invoice' do
        expect {
          post :create, params: { client: client.id, invoice: attributes_for(:invoice) }, format: :json
        }.to change(Invoice, :count).by(1)
      end

      it 'returns a :created status' do
        post :create, params: { client: client.id, invoice: attributes_for(:invoice) }, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it "does not create a new invoice" do
        post :create, params: { client: client.id, invoice: attributes_for(:invoice, invoice_amount: -10.0, status: "closed") }, format: :json
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)["errors"]).to include("Invoice amount must be greater than or equal to 0")
      end   
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it "returns a :ok status" do
        put :update, params: { id: invoice.id, invoice: { status: "approved" } }, format: :json
        expect(response).to have_http_status(:ok)
      end  
    end

    context 'with invalid attributes' do
      it "returns a :unprocessable_entity status" do
        put :update, params: { id: invoice.id, invoice: {status: "closed", due_date: Date.today } }, format: :json
        put :update, params: { id: invoice.id, invoice: {status: "purchased", due_date: Date.today } }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
