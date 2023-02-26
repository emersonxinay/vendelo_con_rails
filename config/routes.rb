Rails.application.routes.draw do
  resources :categories, except: :show
  #refactorizado las rutas
  resources :products, path: '/'
  
end
