Rails.application.routes.draw do
  resources :answers
  resources :games do
    resources :plays
    member do
      post :start
    end
  end
  resources :decks
  resources :cards
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'home#index'
  mount ActionCable.server => '/cable'
end
