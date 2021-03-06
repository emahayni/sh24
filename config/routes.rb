Rails.application.routes.draw do
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :postcodes

  resources :lsoas

  get :service, to: 'service#index'

  get :check, to: 'service#check'
end
