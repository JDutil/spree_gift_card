class AddIndexToGiftCardsCode < ActiveRecord::Migration
  def change
    add_index :spree_gift_cards, :code, :unique => true
  end
end
