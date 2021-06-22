Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy,:new]
    devise_for :users
  
  root 'welcome#index'
  post 'stocks/order', to: 'user_stocks#order', as: 'order_stocks'
  get 'my_portfolio', to:'users#my_portfolio'
  get 'transactions', to:'users#transactions'
  get 'search_stock', to:'stocks#search'
  get 'stocks', to: 'stocks#index', as:  'stocks'
end
