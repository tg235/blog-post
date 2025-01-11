Rails.application.routes.draw do

  resources :letters
  devise_for :users
  devise_scope :user do  
     get '/users/sign_out' => 'devise/sessions#destroy'     
  end
  resources :users, :only =>[:show, :index, :update, :edit]
  resources :blog_posts do
    resources :comments
    collection do
      get :view_drafts
    end
  end
  root to: 'pages#home'
end
