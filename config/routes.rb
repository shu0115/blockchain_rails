Rails.application.routes.draw do
  root to: 'blockchains#index'

  resources :nodes, only: [:index, :create]

  resources :blockchains, only: [:index, :new, :create, :show] do
    post 'transactions/generate', to: 'transactions#generate'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
