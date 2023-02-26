Rails.application.routes.draw do
  # ruta inicio por defecto 
  
  root "products#index"
  delete 'products/:id', to: 'products#destroy'
  patch 'products/:id', to: 'products#update'
  post 'products', to: 'products#create'
  get 'products/new', to: 'products#new', as: :new_product
  # ruta para ver todos los productos
  get '/products', to: 'products#index'
  # ruta para ir al id de cada producto
  get '/products/:id', to: 'products#show', as: :product 
  get '/products/:id/edit', to: 'products#edit', as: :edit_product 

  
  
end
