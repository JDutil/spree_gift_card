Spree::Product.class_eval do

  scope :gift_cards, -> { where(is_gift_card: true) }
  scope :not_gift_cards, -> { where(is_gift_card: false) }

end
