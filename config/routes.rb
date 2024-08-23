Rails.application.routes.draw do
  resources :users, only: [:index]
  resources :videos
  resources :photos
  resources :albums

  root to: "home#index"

  resources :posts do
    member do
      delete :purge_avatar
    end
  end

  delete "attachments/:id/purge", to: "attachments#purge", as: "purge_attachment"
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
end
