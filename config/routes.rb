Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy,:new]
    devise_for :users
  root 'welcome#index'
  get 'my_portfolio', to:'users#my_portfolio'
  get 'search_stock', to:'stocks#search'
  get 'stocks', to: 'stocks#index', as:  'stocks'
end
