Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
  get "calendar", to: "pages#calendar"
  resources :testimonials, only: %i[new create]

  resources :events, only: %i[index show new create edit update delete] do
    resources :participations, only: [:create]
    resources :chatrooms, only: :index do
      resources :messages, only: :create
    end
  end

  mount ActionCable.server => '/cable'
end
