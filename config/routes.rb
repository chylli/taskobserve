Taskobserve::Application.routes.draw do

  controller :signup do
    get 'signup' => :new
    post 'signup' => :create
  end

  get "test/new"

  controller :logon do
    get 'login' => :new
    post 'login' => :create
    #get 'logout' => :destroy
    delete 'logout' => :destroy
  end

  controller :membership do
    get "/membership" => :index
    match "/membership/:id" => :show, :as => "membership"
    match "/membership/:id/shared_tags" => :shared_tags, :as => "membership_shared_tags"
    match "/membership/:id/tasks" => :tasks, :as => "membership_tasks"
    match "/membership/:id/activities" => :activities, :as => "membership_activities"
  end
    
  
  match "/inventory/item/:id" => "inventory#item" , :constraints => {:id => /\d+.*/}, :as => "item"
  match "/inventory/:tag_or_state" => "inventory#show", :as => "inventory" 
  get "/inventory" => "inventory#index"

  match "/activity/:type/:id" => "activity#show", :as => "activity"
  get "/activity" => "activity#index"

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
 root :to => 'root#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
