require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  let(:client) { FactoryBot.create(:client) }

  describe 'POST #create' do
    let(:client) { FactoryBot.create(:client) }
    it "creates a new invoice with an attached file" do
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'invoice.pdf'), 'application/pdf')
      post :create, params: { invoice: { invoice_number: "123", invoice_amount: "100", due_date: "2022-04-30", status: "created", client_id: client.id, invoice_scan: file } }
      expect(response).to have_http_status(:created)
      expect(Invoice.count).to eq(1)
      expect(Invoice.first.invoice_scan).to be_attached
    end

    it 'creates a new invoice with default status' do
      post :create, params: { invoice: { invoice_number: 'INV-123', invoice_amount: 100, due_date: '2022-05-01', client_id: client.id } }
      expect(response).to have_http_status(:created)
      invoice = Invoice.last
      expect(invoice.invoice_number).to eq('INV-123')
      expect(invoice.invoice_amount).to eq(100)
      expect(invoice.due_date).to eq(Date.new(2022, 5, 1))
      expect(invoice.status).to eq('created')
    end
  end

  describe 'PUT #update' do
    let(:invoice) { FactoryBot.create(:invoice, client: client, status: 'created') }

    it 'updates the status of an invoice if status is "created"' do
      put :update, params: { id: invoice.id, invoice: { status: 'approved' } }
      expect(response).to have_http_status(:ok)
      invoice.reload
      expect(invoice.status).to eq('approved')
    end

    it 'does not update the status of an invoice if status is not "created"' do
      invoice.update(status: 'purchased')
      put :update, params: { id: invoice.id, invoice: { status: 'closed' } }
      expect(response).to have_http_status(:unprocessable_entity)
      invoice.reload
      expect(invoice.status).to eq('purchased')
    end
  end
end
