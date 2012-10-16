Spree::OrderMailer.class_eval do
  def gift_card_email(card, order)
    @gift_card = card
    @order = order
    subject = "#{Spree::Config[:site_name]} Gift Card"
    @gift_card.update_attribute(:sent_at, Time.now)
    mail(:to => card.email, :subject => subject)
  end
end
