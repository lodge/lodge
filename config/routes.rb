# coding: utf-8
Rails.application.routes.draw do

  match "articles/:article_id/update_histories", to: 'update_histories#list', via: :get, as: :update_histories
  resources :update_histories, only: [:show]

  devise_for :users, controllers: {
    registrations: 'custom_devise/registrations',
    sessions: 'custom_devise/sessions'
  }

  resources :users, only: [:show]

  match "tags", to: 'tags#index', via: :get
  match "following_tag", to: 'following_tags#destroy', via: :delete, require: :tag_id
  resources :following_tags, :only => [:create]
  resources :stocks, :only => [:index, :create, :destroy]

  match "articles/preview", :to => 'articles#preview', :via => :post
  match "articles/stocks", :to => 'articles#by_stocks', :via => :get, :as => :articles_by_stocks
  match "articles/search", :to => 'articles#search', :via => :get
  match "articles/feed", :to => 'articles#feed', :via => :get, :as => :articles_feed
  resources :articles
  match "articles/:id/comment", :to => 'articles#create_comment', :via => :post
  match "articles/tag/:tag_name", :to => 'articles#by_tag', :via => :get, :as => :articles_by_tag, :constraints => {tag_name: /.+/}
  match "articles/user/:user_id", :to => 'articles#by_user', :via => :get, :as => :articles_by_user
  resources :comments, :only => [:create, :update, :destroy]

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
