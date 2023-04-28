class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
    invoices_with_urls = @invoices.map do |invoice|
      invoice_as_json = invoice.as_json
      if invoice.invoice_scan.attached?
        invoice_as_json['invoice_scan_url'] = url_for(invoice.invoice_scan)
      end
      invoice_as_json
    end

    render json: invoices_with_urls
  end

  def new
    @invoice = Invoice.find(params[:id])
    @client = @invoice.client.new
  end

  def create
    @client = Client.find(params[:client])
    @invoice = @client.invoices.new(invoice_create_params) # Associate the invoice with the client
    @invoice.invoice_scan.attach(params[:invoice][:invoice_scan]) # Attach the uploaded file to the invoice
    @invoice.invoice_number = SecureRandom.alphanumeric(10)

    if @invoice.save
      invoice_as_json = @invoice.as_json
      if @invoice.invoice_scan.attached?
        invoice_as_json['invoice_scan_url'] = url_for(@invoice.invoice_scan)
      end
      render json: invoice_as_json, status: :created
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    if !['closed', 'rejected'].include?(@invoice.status)  # Only allow updates if the status is not closed or rejected (finished states)
      if @invoice.update(invoice_update_params) # Update the invoice attributes based on user input
        @invoice.invoice_scan.attach(params[:invoice][:invoice_scan]) # Attach the uploaded file to the invoice
        invoice_as_json = @invoice.as_json
        if @invoice.invoice_scan.attached?
          invoice_as_json['invoice_scan_url'] = url_for(@invoice.invoice_scan)
        end
        render json: invoice_as_json, status: :ok
      else
        render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'The invoice cannot be updated because it is already in a finished state.' }, status: :unprocessable_entity
    end
  end
  
  private
  
  def invoice_update_params
    params.require(:invoice).permit(:status, :invoice_scan, :invoice)
  end
  
  def invoice_create_params
    params.require(:invoice).permit(:invoice_number, :invoice_amount, :due_date, :client, :invoice_scan)
  end

  before_action :set_default_status, only: [:create]

  def set_default_status
    params[:invoice][:status] = 0
  end

end
