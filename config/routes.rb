Rails.application.routes.draw do
  resources :transactions
  resources :auctions
  devise_for :users
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :arts
      resource :sessions, only: %i[create show]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
