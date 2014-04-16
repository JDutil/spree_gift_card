class AddUserIdToSpreeGiftCards < ActiveRecord::Migration
  def change
    add_reference :spree_gift_cards, :user, index: true
  end
end
