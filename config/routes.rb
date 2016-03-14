Rails.application.routes.draw do
  root 'home#test'
  get '/auth/:provider/callback', to: 'sessions#create'

  get 'search' => 'queries#new', as: :new_query
  get 'hashtag-query' => 'queries#search'
  get 'hashtag-query/waiting' => 'queries#waiting', as: :query_waiting

  get 'my-search-history' => 'profile#searches', as: :searches
end