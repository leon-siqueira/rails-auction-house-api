Rails.application.routes.draw do
  devise_for :users, skip: %i[sessions registrations passwords confirmations],
  controllers: {
    confirmation: 'users/confirmations',
    registrations: 'users/registrations'
  }
  as :user do
    post 'api/v1/users', to: 'users/registrations#create', as: :create_user
    put 'api/v1/users', to: 'users/registrations#update', as: :update_user
    patch 'api/v1/users', to: 'users/registrations#update', as: :patch_user
    delete 'api/v1/users', to: 'users/registrations#destroy', as: :destroy_user
  end
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :arts
      resources :bids, only: %i[create show]
      resources :auctions, only: %i[create show destroy index] do
        resources :bids, only: %i[index]
      end
      resource :sessions, only: %i[create show destroy]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
