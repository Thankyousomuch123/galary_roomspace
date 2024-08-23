Rails.application.routes.draw do
  # get 'home/index'
  root to: "home#index"
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
end
