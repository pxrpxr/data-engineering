DataEngineering::Application.routes.draw do
  resources :orders
  resources :merchants
  resources :products
  resources :users
  # Want to use a human-understandable url
  get '/' => 'uploader#index'
  post '/upload' => 'uploader#upload'

  root 'uploader#index'
end
