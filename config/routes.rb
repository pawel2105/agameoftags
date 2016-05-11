Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'home#test'

  resources :batches, only: [:index]

  # Sessions
  get '/auth/:provider/callback', to: 'sessions#create'
  delete "/users/sign_out" => "sessions#destroy", as: :destroy_session

  # Profile and searches
  get 'new-search' => 'queries#new', as: :new_query
  get 'hashtag-query' => 'queries#search'
  get 'hashtag-query/processing' => 'queries#waiting', as: :query_waiting
  get 'my-search-history' => 'profile#searches', as: :searches

  # Results page
  get 'query/:id/results' => 'results#show', as: :results

  # FAQ page
  get 'help' => 'faq#faq', as: :faq
  get 'privacy-policy' => 'faq#privacy', as: :privacy
  get 'terms' => 'faq#terms', as: :terms

  # Admin
  get 'stats' => 'stats#index', as: :stats
end