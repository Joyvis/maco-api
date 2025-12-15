Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v0 do
      resources :transactions, only: [:create, :index, :destroy, :update]
      resources :categories, only: [:create, :index, :destroy, :update], path: 'transaction_categories'
      resources :payment_methods, only: [:create, :index, :destroy, :update] do
        resources :invoices, only: :create, controller: 'payment_methods/invoices'
      end
    end
  end
end
