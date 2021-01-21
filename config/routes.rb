Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', passwords: 'users/passwords', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'

  # Users Controller
  get 'users', to: 'users#index'
  post 'users/:id/approve', to: 'users#approve_as_admin', as: :approve_as_admin
  patch 'users/attach_avatar', to: 'users#attach_avatar', as: :attach_avatar
  get 'settings', to: 'users#settings', as: :settings
  patch 'update_settings', to: 'users#update_settings', as: :update_settings
  patch 'update_password', to: 'users#update_password', as: :update_password

  # Recipes Controller
  resources :recipes do
    post '/comments', to: 'recipe_comments#create'
    delete '/comments/:id', to: 'recipe_comments#destroy', as: :comment_destroy
  end

  # PhotoAlbums Controller
  resources :photo_albums

  # Messages Controller
  resources :messages do
    post '/comments', to: 'message_comments#create'
    delete '/comments/:id', to: 'message_comments#destroy', as: :comment_destroy
  end
end
