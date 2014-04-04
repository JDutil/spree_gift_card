Spree::Core::Engine.routes.draw do
  resources :gift_cards

  get "/account/gift_cards", to: "users#gift_cards", as: :account_gift_cards

  namespace :admin do
    resources :gift_cards do
      member do
        put :void
        put :restore
      end
    end
  end
end
