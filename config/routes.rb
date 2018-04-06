Rails.application.routes.draw do
  mount Commontator::Engine => '/commontator'
  
  resources :marketing_requests do
    member do
      put :complete
      put :reopen
    end
  end

  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'marketing_requests#index'
  devise_for :users
  resources :users
end
