Spree::Adjustment.class_eval do
  scope :gift_card, -> { where(:source_type => 'Spree::GiftCard') }
end
