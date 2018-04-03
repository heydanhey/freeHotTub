Rails.application.routes.draw do
  get '/' => 'fhts#index'
  get '/analytics' => 'fhts#analytics'
  namespace :api do
    get '/' => 'fhts#index'
  end
end
