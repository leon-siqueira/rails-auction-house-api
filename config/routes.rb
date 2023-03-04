Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :arts
      resources :bids, only: %i[create show]
      resources :auctions, only: %i[create show destroy] do
        resources :bids, only: %i[index]
      end
      resource :sessions, only: %i[create show]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
