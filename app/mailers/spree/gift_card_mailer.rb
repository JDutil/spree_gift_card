class Spree::GiftCardMailer < Spree::BaseMailer

  def gift_card_issued gift_card
    @gift_card = gift_card
    mail(to: gift_card.email, from: from_address, subject: t(:gift_card_issued_subject))
  end
end
