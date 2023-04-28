class ClientsController < ApplicationController
  def index
    @clients = Client.all
    render json: @clients, include: :invoices
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
