Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      post '/suggestions', to: 'suggestions#create'
      post '/users', to: 'users#create'
      get '/suggestions', to: 'suggestions#index'
    end
  end
end
