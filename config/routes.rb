Mobilenews::Application.routes.draw do

  match "blog#index", :constraints => {:subdomain => "blog"}
  #root :to => "blog#index"
  
  root :to => "pages#main"

  resources :posts

end
