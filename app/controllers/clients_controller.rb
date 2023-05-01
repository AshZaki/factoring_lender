class ClientsController < ApplicationController
  def index
    @clients = Client.all
    client_data = @clients.map do |client|
      client_as_json = client.as_json
      client_as_json['invoices'] = client.invoices.map do |invoice|
        # Round the invoice_amount to 2 decimal places
        invoice_as_json = invoice.as_json
        invoice_as_json['invoice_amount'] = invoice.invoice_amount.round(2)
        invoice_as_json
      end
      client_as_json
    end
    render json: client_data
  end
  

  def new
    @client = Client.find(params[:id])
    @invoice = @client.invoices.new
  end


  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client, status: :created
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      render json: @client, status: :ok
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name)
  end
end
