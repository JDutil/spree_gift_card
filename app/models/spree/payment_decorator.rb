Spree::Payment.class_eval do
  after_update :send_gift_card, if: :gift_card_valid_state_transition?

  def send_gift_card 
    order.line_items.each do |li|
      Spree::OrderMailer.gift_card_email(li.gift_card.id, order).deliver if li.gift_card
    end
  end

  def gift_card_valid_state_transition?
    state_changed? && state_was != 'completed' && state == 'completed'
  end
end
