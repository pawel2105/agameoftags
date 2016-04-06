Rails.application.routes.draw do
  root 'home#test'

  # Sessions
  get '/auth/:provider/callback', to: 'sessions#create'
  delete "/users/sign_out" => "sessions#destroy", as: :destroy_session

  # Profile and searches
  get 'search' => 'queries#new', as: :new_query
  get 'hashtag-query' => 'queries#search'
  get 'hashtag-query/waiting' => 'queries#waiting', as: :query_waiting
  get 'my-search-history' => 'profile#searches', as: :searches

  # Results page
  get 'query/:id/results' => 'results#show', as: :results

  # Admin
  get 'stats' => 'stats#index', as: :stats
end