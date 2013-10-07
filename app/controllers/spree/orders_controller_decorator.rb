Spree::OrdersController.class_eval do

  Spree::PermittedAttributes.checkout_attributes << :gift_code

  durably_decorate :after_update_attributes, mode: 'soft', sha: 'bdc8fc02ee53912eda684bdd37a6266594665866' do
    apply_gift_code
    original_after_update_attributes
  end

end
