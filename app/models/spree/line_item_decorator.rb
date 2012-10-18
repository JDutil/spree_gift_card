Spree::LineItem.class_eval do

  has_one :gift_card

  validates :gift_card, presence: { if: Proc.new{ |item| item.product.is_gift_card? } }

end
