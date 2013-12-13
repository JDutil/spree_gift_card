Spree::Order.class_eval do

  attr_accessible :gift_code
  attr_accessor :gift_code

  # If variant is a gift card we say order doesn't already contain it so that each gift card is it's own line item.
  def find_line_item_by_variant(variant)
    return false if variant.product.is_gift_card?
    line_items.detect { |line_item| line_item.variant_id == variant.id }
  end

  # Finalizes an in progress order after checkout is complete.
  # Called after transition to complete state when payments will have been processed.
  def finalize_with_gift_card!
    finalize_without_gift_card!
    # Record any gift card redemptions.
    self.adjustments.where(originator_type: 'Spree::GiftCard').each do |adjustment|
      adjustment.originator.debit(adjustment.amount, self)
    end
  end
  alias_method_chain :finalize!, :gift_card

  # Tells us if there is the specified gift code already associated with the order
  # regardless of whether or not its currently eligible.
  def gift_credit_exists?(gift_card)
    adjustments.gift_card.reload.detect{ |credit| credit.originator_id == gift_card.id }.present?
  end

end
