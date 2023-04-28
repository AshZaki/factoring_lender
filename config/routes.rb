Rails.application.routes.draw do

  get 'home/index'
  get 'invoices/index'
  # get 'invoices/new'
  get 'invoices/create'
  get 'invoices/show'
  get 'invoices/edit'
  get 'invoices/update'
  get 'clients/index'
  get 'clients/new'
  get 'clients/create'
  get 'clients/show'
  get 'clients/edit'
  get 'clients/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :invoices, :clients
end
