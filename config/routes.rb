Rails.application.routes.draw do
  scope module: :api, constraints: { format: :json } do
    namespace :v1 do
      resources :restaurants, only: :index
    end
  end
end
