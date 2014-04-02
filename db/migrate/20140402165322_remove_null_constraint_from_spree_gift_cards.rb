class RemoveNullConstraintFromSpreeGiftCards < ActiveRecord::Migration
  def change
    change_column :spree_gift_cards, :variant_id, :integer, null: true
  end
end
