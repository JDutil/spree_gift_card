module Spree::Admin::GiftCardsHelper
  def variants_values(gift_card_variants)
    gift_card_variants.map { |variant| [variant.display_price, variant.id] }
  end
end
