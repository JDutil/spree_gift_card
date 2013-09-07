module Spree
  module Stock
    Quantifier.class_eval do
      durably_decorate :can_supply?, mode: 'soft', sha: '2759d397d8dafe5bc3e5eed2d881fa0ab3a1a7c9' do |required|
        # TODO can use original method when my pr gets merged to durable_decorator
        # original_can_supply?(required) || Spree::Variant.find(@variant).product.is_gift_card?
        total_on_hand >= required || backorderable? || Spree::Variant.find(@variant).product.is_gift_card?
      end
    end
  end
end
