Rails.application.routes.draw do
  root to: "home#index"

  resources :users, only: [:index]

  resources :albums do
    member do
      get :share
      patch :update_share
      delete :purge_avatar
    end
    resources :photos, only: [:new, :create, :destroy] do
      member do
        get :share
        patch :update_share
      end
    end
    resources :videos, only: [:new, :create, :destroy] do
      member do
        get :share
        patch :update_share
      end
    end
  end

  delete "attachments/:id/purge", to: "attachments#purge", as: "purge_attachment"

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
end
