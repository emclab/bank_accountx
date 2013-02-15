Rails.application.routes.draw do

  mount Authentify::Engine => "/authentify/", :as => :authentify
  mount BankAccountx::Engine => "/bank_accountx"
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  
end
