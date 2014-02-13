Spree::OrdersController.class_eval do

  durably_decorate :after_update_attributes, mode: 'soft', sha: '4a4bdc54d88160bed9de2b5ae64d9f5715cbf99a' do
    apply_gift_code
    original_after_update_attributes
  end

end
