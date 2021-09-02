require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', passwords: 'users/passwords', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/skip_profile_photo_upload', to: 'dashboard#skip_profile_photo_upload', as: :skip_profile_photo_upload

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Users Controller
  #
  # Admin only
  #
  get 'users', to: 'users#index'
  post 'users/:id/approve', to: 'users#approve_as_admin', as: :approve_as_admin
  get 'users/admin_photo_album', to: 'users#admin_photo_album', as: :admin_photo_album
  post 'users/create_admin_photo_album', to: 'users#create_admin_photo_album', as: :create_admin_photo_album
  patch 'users/update_admin_photo_album', to: 'users#update_admin_photo_album', as: :update_admin_photo_album
  delete 'users/destroy_photo_from_admin_photo_album/:image_id', to: 'users#destroy_photo_from_admin_photo_album', as: :destroy_photo_from_admin_photo_album
  get 'users/admin_family_tree', to: 'users#admin_family_tree', as: :admin_family_tree
  post 'users/create_admin_family_tree', to: 'users#create_admin_family_tree', as: :create_admin_family_tree
  delete 'users/family_tree_photo', to: 'users#destroy_family_tree_photo', as: :destroy_family_tree_photo

  #
  # End Admin Only
  #
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

  # Family Controller
  get '/family/tree', to: 'family#tree', as: :family_tree
  get '/family/bios', to: 'family#bios', as: :family_bios

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
