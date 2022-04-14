Rails.application.routes.draw do
  root                to: 'searches#top'
  get 'around_shops', to: 'searches#around_shops'
  resource :shop, only: [:show]
  resources :reviews, only: [:index, :create, :update, :destroy] do
    collection do
      get 'current_reviews', action: 'current_index'
    end
  end
  resources :favorites, only: [:index, :create, :destroy]
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
end
