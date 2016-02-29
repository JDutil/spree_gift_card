Spree::Payment.class_eval do
  after_update :send_gift_card

  def send_gift_card
    if state_changed? && state_was != 'completed' && state == 'completed'
      order.line_items.each do |li|
        Spree::OrderMailer.gift_card_email(li.gift_card.id, order).deliver if li.gift_card
      end
    end
  end
end
