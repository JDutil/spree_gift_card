Spree::Adjustment.class_eval do

  scope :gift_card, where(:originator_type => 'Spree::GiftCard')

end
