# coding: utf-8
Rails.application.routes.draw do

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
      get :owned, path: "user/:user_id"
      get :tagged, path: "tag/:tag"
    end

    member do
      post "stock"
      post "unstock"
    end
  end

  resources :update_histories, only: [:show] do
    collection do
      get :article, action: :list, path: "article/:article_id"
    end
  end

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
