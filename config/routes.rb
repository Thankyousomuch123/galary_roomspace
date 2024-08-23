Rails.application.routes.draw do
  resources :users, only: [:index]
  resources :videos
  resources :photos
  resources :albums

  resources :albums do
    member do
      delete :purge_avatar
    end
    member do
      get :share
      patch :update_share
    end
    resources :photos, only: [:new, :create, :destroy] do
      member do
        get :share
        patch :update_share
      end
    end
  end

  root to: "home#index"

  delete "attachments/:id/purge", to: "attachments#purge", as: "purge_attachment"
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
end
