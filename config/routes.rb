Rails.application.routes.draw do
  # root to: 'blockchains#index'
  root to: 'blocks#index'

  resources :blocks,       only: [:index] do
    collection do
      get 'confirmation'
      get 'list_api'
      get 'list_sync'
    end
  end

  resources :transactions, only: [:create]

  resources :nodes, only: [:index, :create, :destroy] do
    collection do
      get 'list_api'
    end
  end

  # resources :blockchains, only: [:index, :new, :create, :show] do
  #   post 'transactions/generate', to: 'transactions#generate'
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
