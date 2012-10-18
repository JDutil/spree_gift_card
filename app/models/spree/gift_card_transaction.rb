class Spree::GiftCardTransaction < ActiveRecord::Base
  belongs_to :gift_card
  belongs_to :order

  validates :amount, presence: true
  validates :gift_card, presence: true
  validates :order, presence: true
end
