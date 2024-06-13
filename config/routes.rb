Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'homepage#index'

  namespace :api, constraints: { format: /json/ } do
    namespace :v1 do
      resources :mazes, only: [] do
        collection do
          post :start
          post :search
        end
      end
    end
  end
end
