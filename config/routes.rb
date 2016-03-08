Spree::Core::Engine.routes.draw do
  resources :gift_cards

  resources :orders do
    put :apply_gift_card
  end

  namespace :admin do
    resources :gift_cards
  end
end
