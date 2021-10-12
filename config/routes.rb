Rails.application.routes.draw do

  devise_scope :user do
    root :to => "home#top"
    get "signup", :to => "users/registrations#new"
    get "signup/:family_id" => "users/registrations#invite_user_new", as: :invite_signup
    get "verify", :to => "users/registrations#verify"
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
    
  end
  
     
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords',
    :confirmations => 'users/confirmations',
    :unlocks => 'users/unlocks',
  } 
  
  
  resources :cats do
    member do
      get "home"
    end
    
    get 'records' => 'target_daily_records#index', as: :records
    get 'records/chart/:year/:month' => 'target_daily_records#chart', as: :records_chart
    post 'records/:display_day' => 'target_daily_records#create'
    get 'records/new/:display_day' => 'target_daily_records#new', as: :new_record
    get 'records/edit/:display_day' => 'target_daily_records#edit', as: :edit_record
    get 'records/:display_day' => 'target_daily_records#show', as: :record
    patch 'records/:display_day' => 'target_daily_records#update'
    put 'records/:display_day' => 'target_daily_records#update'
    delete 'records/:display_day' => 'target_daily_records#destroy'
    
  end
  
  resources :families
  resources :daily_records
  resources :invitations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
