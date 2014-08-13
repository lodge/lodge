# coding: utf-8
Rails.application.routes.draw do

  match "articles/:article_id/update_histories", to: 'update_histories#list', via: :get, as: :update_histories
  resources :update_histories, only: [:show]

  devise_for :users, controllers: {
    registrations: 'custom_devise/registrations',
    sessions: 'custom_devise/sessions',
    omniauth_callbacks: 'custom_devise/omniauth_callbacks',
  }

  resources :users, only: [:show]
  resources :tags, only: [:index], param: :tag do
    collection do
      get "list"
    end
    member do
      post "follow"
      post "unfollow"
    end
  end

  resources :articles do
    collection do
      post :preview
      get :search
      get :stocked
      get :feed
    end

    member do
      post "stock"
      post "unstock"
    end
  end

  match "articles/:id/comment", :to => 'articles#create_comment', :via => :post
  match "articles/tag/:tag", :to => 'articles#by_tag', :via => :get, :as => :articles_by_tag, :constraints => {tag: /.+/}
  match "articles/user/:user_id", :to => 'articles#by_user', :via => :get, :as => :articles_by_user
  resources :comments, :only => [:create, :update, :destroy]
  resources :images, only: :create, defaults: { format: 'json' }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'articles#feed'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
