class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
    invoice_data = @invoices.map do |invoice|
      invoice_as_json = invoice.as_json
  
      # Round the invoice_amount to 2 decimal places
      invoice_as_json['invoice_amount'] = invoice.invoice_amount.round(2)
  
      if invoice.invoice_scan.attached?
        invoice_as_json['invoice_scan_url'] = url_for(invoice.invoice_scan)
      end
      invoice_as_json
    end
  
    render json: invoice_data
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

    if @invoice.valid? && @invoice.save
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
    # Only allow updates if the status is not closed or rejected (finished states)
    if !['closed', 'rejected'].include?(@invoice.status)
      @invoice.assign_attributes(invoice_update_params)
      if @invoice.save()
        # Attach the uploaded file to the invoice
        @invoice.invoice_scan.attach(params[:invoice][:invoice_scan])
        invoice_as_json = @invoice.as_json
        if @invoice.invoice_scan.attached?
          invoice_as_json['invoice_scan_url'] = url_for(@invoice.invoice_scan)
        end
        render json: invoice_as_json, status: :ok
      else
        render json: { errors: @invoice.errors.full_messages, invoice: @invoice.as_json }, status: :unprocessable_entity
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
    params[:invoice][:status] = "created"
  end
end
