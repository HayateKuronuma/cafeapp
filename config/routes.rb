Rails.application.routes.draw do
  root to: 'home#top'
  get 'around_shops', to: 'home#around_shops'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
