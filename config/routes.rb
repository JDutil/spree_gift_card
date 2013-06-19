Spree::Core::Engine.routes.draw do
  resources :gift_cards
  namespace :admin do
    resources :gift_cards do
      put 'delete_my_batch_unused', :on => :member
    end
  end
end
