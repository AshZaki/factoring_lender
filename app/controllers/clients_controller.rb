class ClientsController < ApplicationController
  def index
    @clients = Client.all
    render json: @clients
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
  end

  private

  def client_params
    params.require(:client).permit(:name, :invoice_number)
  end
end
