Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "videos#index"

  resources :videos, only: [:index, :create]
  post '/login', to: 'authenticate#login'
end
