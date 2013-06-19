class AddBatchIdToGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :batch_id, :integer, :null => true
    add_index  :spree_gift_cards, :batch_id
  end
end
