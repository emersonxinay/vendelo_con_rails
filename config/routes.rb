Rails.application.routes.draw do
  resources :categories
  #refactorizado las rutas
  resources :products, path: '/'
  
end
