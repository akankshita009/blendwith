Blendwith::Application.routes.draw do

  root :to => "public#index"

  get "/tour" => "public#tour"
  opinio_model :controller => 'my_comments'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)


  resources :video_urls
  resources :uploaded_photos
  resources :collections

  resources :music_urls do
    post :create_all, :on => :collection
  end

  resources :photo_urls, :only => [:new, :create, :destroy, :update] do
    delete 'delete_many', :on => :collection
  end

  match '/auth/:provider/callback' => 'services#create'
  resources :services, :only => [:index, :create]

  #match "/facebook" => "photo_networks#facebook"
  #match "/instagram" => "photo_networks#instagram"
  #match "/picasa" => "photo_networks#picasa"
  #match "/twitter" => "photo_networks#twitter"
  #match "/flickr" => "photo_networks#flickr"
  #match "/url" => "photo_networks#url"
  #match "/soundcloud" => "music_networks#soundcloud"
  #match "/youtube" => "video_networks#youtube"

  match "/facebook" => "image_playlists#show"
  match "/instagram" => "image_playlists#show"
  match "/googleplus" => "image_playlists#show"
  match "/twitter" => "image_playlists#show"
  match "/flickr" => "image_playlists#show"
  match "/soundcloud" => "music_playlists#show"
  match "/youtube" => "video_playlists#show"

  match "/uploader" => "photo_networks#uploader"
  put "/update_uploader/:id" => "photo_networks#update_uploader", :as => :update_photo_uploader

  post "/playlist_box_session" => "home#playlist_box_session"
  get "home/:social/social_login" => "home#social_login"
  get "/tour/update"    => "friend_maps#update_tour"

  devise_for :users, :controllers => { :omniauth_callbacks => 'services', :sessions => "users/sessions" }

  resources :playlists, :only => [:update, :destroy] do
    post :toggle_feed, :on => :member
  end

  resources :image_playlists do
    post 'add_item', :on => :member
    delete 'delete_media', :on => :collection
    get :image_playlist_by_id, :on => :member
    get :background_music_list, :on => :collection
    get :recent, :on => :collection
  end
  
  resources :music_playlists do
    post 'add_item', :on => :member
    delete :delete_item, :on => :collection
    put :update_track, :on => :member, :as => :update_track
  end

  resources :video_playlists do
    post 'add_item', :on => :member
    delete :delete_item, :on => :collection
  end

  get "/embed/:token" => "users#embed"

  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash
    end
    collection do
      get :inbox
      get :sent_box
      get :trash_box
    end
  end

  resources :users, :only => [:show, :edit, :update, :destroy] do
    opinio
    post :privacy, :on => :collection
    post :friend_request, :on => :collection
    get :connect_social_network, :on => :collection
    post :disconnect_social_network, :on => :collection
    put :update_password, :on => :collection
    get :new_twitter_user, :on => :collection
    post :create_twitter_user, :on => :collection
    get :user_comments, :on => :member
    resources :uploaded_photos do
      collection do
        post :upload_photos
      end
    end
    resources :cover_photos do
      collection do
        post :upload_photos
      end
    end
    resources :profile_photos do
      collection do
        post :upload_photos
      end
    end
  end

  post "users/user-gallery.php" => "users#user_gallery"
  post "users/ajax-gallery.php" => "users#ajax_gallery"
  post "users/player.php" => "users#player"
  post "users/user_gallery_album" => "users#user_gallery_album"
  post "users/photo_player" => "users#photo_player"

  resources :uploaded_videos do
    post :authorize_upload, :on => :collection
  end

  resources :uploaded_audios do
    post :authorize_upload, :on => :collection
  end

  resources :ajax, :controller => :ajax, :only => :none do
    get :soundcloud_embed, :on => :collection
  end
  get "/feed/:item_id/toggler" => "ajax#feed_item_toggler", :as => :feed_toggler
  get "/change/:playlist_id/cover_from/:item_id" => "ajax#change_playlist_cover_from_media", :as => :playlist_cover_changer

  resources :friend_maps do
    get :pending_friends, :on => :collection
    get :request_friends, :on => :collection
    get :friends, :on => :collection
    post :add_friend, :on => :collection
    post :agree_request, :on => :collection
    #get :friend_profile, :on => :member
    get :friends_feed, :on => :collection
  end

  resources :photos, :only => [:show, :update, :destroy]
  resources :albums, :only => [:show, :update, :destroy] do
    delete :delete_photo, :on => :collection
  end
  resources :tracks, :only => [:show, :update, :destroy]
  resources :videos, :only => [:show, :update, :destroy] do
    member do
      get :preview
    end
  end

  get '/:username' => "users#show"

  resources :track_albums, :only => [:show] do
    delete :delete_track, :on => :collection
  end

  resources :video_albums, :only => [:show] do
    delete :delete_video, :on => :collection
  end

 match '/users/sign_in' => "devise/sessions#new", :as => :create_user_session

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
