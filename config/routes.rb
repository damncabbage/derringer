Derringer::Application.routes.draw do
  match '/search' => 'searches#search', :as => :search, :via => :get

  resources :orders, :only => [:show] do
    member do
      post 'scan'
      post 'scan_tickets'
    end
  end

  resources :tickets, :only => [:show] do
    post 'scan', :on => :member
  end

  match '/settings' => 'settings#index', :as => :settings,   :via => :get
  match '/stats' => 'statistics#index',  :as => :statistics, :via => :get

  root :to => 'searches#search'
end
