Spree.user_class.class_eval do
  has_many :gift_cards, foreign_key: "user_id"
end
