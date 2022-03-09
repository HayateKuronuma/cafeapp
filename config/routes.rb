Rails.application.routes.draw do
  root to: 'searches#top'
  devise_for :users
  get 'shops', to: 'shops#show'
  get 'around_shops', to: 'searches#around_shops'
  resources :reviews, only: [:create, :edit, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
