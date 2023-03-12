Rails.application.routes.draw do
  resources :categories, except: :show
  #refactorizado las rutas
  resources :products, path: '/'
  namespace :authentication, path: '', as: '' do
    resources :users, only: [:new, :create]
  end
end
