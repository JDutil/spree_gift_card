Spree::OrdersController.class_eval do

  Spree::PermittedAttributes.checkout_attributes << :gift_code

  after_filter :apply_gift_code, only: :update

end
