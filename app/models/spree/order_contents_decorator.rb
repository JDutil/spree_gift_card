Spree::OrderContents.class_eval do

  # Get current line item for variant if exists
  # Add variant qty to line_item
  def add(variant, quantity = 1, currency = nil, shipment = nil)
    # If variant is a gift card we say order doesn't already contain it so that each gift card is it's own line item.
    if variant.product.is_gift_card?
      line_item = nil
    else
      line_item = order.find_line_item_by_variant(variant)
    end
    add_to_line_item(line_item, variant, quantity, currency, shipment)
  end

end
