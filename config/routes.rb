Rails.application.routes.draw do
  #refactorizado las rutas
  resources :products, path: '/'
  
end
