Rails.application.routes.draw do
  mount Commontator::Engine => '/commontator'

  resources :marketing_requests do
    member do
      put :accept
      put :reject
      put :reopen
    end
  end

  get "document_download/:uuid" => "assets#document_download", as: :document

  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'marketing_requests#index'
  devise_for :users
  resources :users
end
