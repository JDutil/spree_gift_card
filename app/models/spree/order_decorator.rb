Spree::Order.class_eval do

  attr_accessible :gift_code
  attr_accessor :gift_code

  # Tells us if there is the specified gift code already associated with the order
  # regardless of whether or not its currently eligible.
  def gift_credit_exists?(gift_card)
    !! adjustments.gift_card.reload.detect { |credit| credit.originator_id == gift_card.id }
  end

  # unless self.method_defined?('update_adjustments_with_promotion_limiting')
  #   def update_adjustments_with_promotion_limiting
  #     update_adjustments_without_promotion_limiting
  #     return if adjustments.promotion.eligible.none?
  #     most_valuable_adjustment = adjustments.promotion.eligible.max{|a,b| a.amount.abs <=> b.amount.abs}
  #     current_adjustments = (adjustments.promotion.eligible - [most_valuable_adjustment])
  #     current_adjustments.each do |adjustment|
  #       adjustment.update_attribute_without_callbacks(:eligible, false)
  #     end
  #   end
  #   alias_method_chain :update_adjustments, :promotion_limiting
  # end

  # Finalizes an in progress order after checkout is complete.
  # Called after transition to complete state when payments will have been processed
  def finalize_with_gift_card!
    finalize_without_gift_card!
    self.line_items.each do |li|
      Spree::OrderMailer.gift_card_email(li.gift_card, self).deliver if li.gift_card
    end
  end
  alias_method_chain :finalize!, :gift_card

  def contains?(variant)
    return false if variant.product.is_gift_card?
    line_items.detect{ |line_item| line_item.variant_id == variant.id }
  end

end
