Rails.application.routes.draw do
  root 'home#intro'
  get '/auth/:provider/callback', to: 'sessions#create'
end