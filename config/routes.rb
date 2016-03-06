Rails.application.routes.draw do
  root 'home#intro'
  get '/auth/:provider/callback', to: 'sessions#create'

  get 'hashtag-query' => 'queries#search'
  get 'hashtag-query/waiting' => 'queries#waiting', as: :query_waiting
end