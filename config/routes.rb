Rails.application.routes.draw do
  root                to: 'searches#top'
  get 'around_shops', to: 'searches#around_shops'
  resource :shop, only: [:show]
  resources :reviews, only: [:index, :create, :update, :destroy]
  resources :favorites, only: [:index, :create, :destroy]
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
