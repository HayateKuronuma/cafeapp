Rails.application.routes.draw do
  get 'shops/show'
  root to: 'searches#top'
  get 'around_shops', to: 'searches#around_shops'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
