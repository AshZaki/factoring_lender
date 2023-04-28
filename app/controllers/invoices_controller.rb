class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
    render json: @invoices
  end

  def new
    @invoice = Invoice.find(params[:id])
    @client = @invoice.client.new
  end

  def create
    @client = Client.find(params[:client])
    @invoice = @client.invoices.new(invoice_create_params) # Associate the invoice with the client

    if @invoice.save
      render json: @invoice, status: :created
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.status == 'created' # Only allow updates if the status is still 'created'
      if @invoice.update(invoice_update_params) # Update the invoice attributes based on user input
        render json: @invoice, status: :ok
      else
        render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'Invoice status cannot be updated.' }, status: :unprocessable_entity
    end
  end
  
  private
  
  def invoice_update_params
    params.require(:invoice).permit(:status)
  end
  
  def invoice_create_params
    params.require(:invoice).permit(:invoice_number, :invoice_amount, :due_date, :status, :client)
  end
end
