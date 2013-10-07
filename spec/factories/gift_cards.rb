FactoryGirl.define do
  factory :gift_card, class: Spree::GiftCard do
    email 'spree@example.com'
    name 'Example User'
    variant
    line_item
  end
end
