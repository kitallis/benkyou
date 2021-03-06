Rails.application.routes.draw do
  resources :games do
    resources :plays, only: [:show, :create] do
      resources :answers, only: [:create]
    end

    resources :player_search, only: [:index]

    member do
      post :start
    end
  end

  resources :decks do
    member do
      post :import
    end

    resources :cards
  end

  resources :player_search, only: [:index]
  resources :deck_search, only: [:index]
  resources :about, only: [:index]

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  root to: "home#index"

  mount ActionCable.server => "/cable"
end
