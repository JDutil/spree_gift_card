Spree::OrderMailer.class_eval do
  def gift_card_email(card_id, order_id)
    @gift_card = Spree::GiftCard.find(card_id)
    @order = Spree::Order.find(order_id)
    subject = "#{Spree::Store.current.name} #{Spree.t('gift_card_email.subject')}"
    @gift_card.update_attribute(:sent_at, Time.now)
    if @gift_card.variant.images.present?
      attachments.inline['image.jpg'] = File.read(@gift_card.variant.images.first.attachment.path(:product))
    end
    mail(:to => @gift_card.email, :from => from_address, :subject => subject)
  end
end
