if Spree::Product.gift_cards.count == 0
  puts "\tCreating default gift card..."
  product = Spree::Product.new(available_on: Time.now, name: "Gift Card", is_gift_card: true, permalink: 'gift-card', price: 0)
  option_type = Spree::OptionType.new(name: "is-gift-card", presentation: "Value")
  product.option_types << option_type
  [25, 50, 75, 100].each do |value|
    option_value = Spree::OptionValue.new(name: value, presentation: "$#{value}")
    option_value.option_type = option_type
    opts = { price: value.to_i, sku: "GIFTCERT#{value}" }
    opts.merge!({ on_hand: 1000 }) if Spree::Config[:track_inventory_levels]
    variant = Spree::Variant.new(opts)
    variant.option_values << option_value
    product.variants << variant
  end
  product.save
end
