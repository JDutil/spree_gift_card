Spree::Core::Engine.routes.draw do
  resources :gift_cards
  namespace :admin do
    resources :gift_cards do
      member do
        put :void
      end
    end
  end
end
