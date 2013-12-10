Spree::Order.class_eval do

  attr_accessible :gift_code
  attr_accessor :gift_code

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
