Spree::LineItem.class_eval do

  has_one :gift_card, dependent: :destroy

  validates :gift_card, presence: { if: Proc.new{ |item| item.product.is_gift_card? } }
  validates :quantity,  numericality: { if: Proc.new{ |item| item.product.is_gift_card? }, less_than_or_equal_to: 1 }

end
