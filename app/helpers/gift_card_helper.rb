module GiftCarrd
  def variants_values(gift_card_variants)
    gift_card_variants.map { |variant| [variant.display_price, variant.id] }
  end
end