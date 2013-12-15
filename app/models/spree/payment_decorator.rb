Spree::Payment.class_eval do
  before_update :send_gift_card, :if => "state_changed? && state_was != 'completed' && state == 'completed'"

  def send_gift_card
    order.line_items.each do |li|
      Spree::OrderMailer.gift_card_email(li.gift_card, order).deliver if li.gift_card
    end
  end
end