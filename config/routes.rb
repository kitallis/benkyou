Rails.application.routes.draw do
  resources :games do
    resources :plays, only: [:show] do
      resources :answers, only: [:create]
    end
    member do
      post :start
    end
  end
  resources :decks
  resources :cards
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  root to: "home#index"
  mount ActionCable.server => "/cable"
end
