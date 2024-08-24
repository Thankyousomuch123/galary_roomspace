Rails.application.routes.draw do
  root to: "home#index"

  resources :users, only: [:index]

  resources :albums do
    member do
      delete :purge_avatar
      patch :share  # Route for sharing an album
    end
    
    resources :photos, only: [:new, :create, :destroy] do
      member do
        get :share   # Route for showing the share modal for a photo
        patch :share # Route for sharing a photo
      end
    end
    
    resources :videos, only: [:new, :create, :destroy] do
      member do
        get :share   # Route for showing the share modal for a video
        patch :share # Route for sharing a video
      end
    end
  end

  delete "attachments/:id/purge", to: "attachments#purge", as: "purge_attachment"

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Route for shared items (albums, photos, videos)
  resources :shared_items, only: [:index]
end
