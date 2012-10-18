class CreateSpreeGiftCards < ActiveRecord::Migration
  def change
    create_table :spree_gift_cards do |t|
      t.integer :variant_id, :null => false
      t.integer :line_item_id
      t.string :email, :null => false
      t.string :name
      t.text :note
      t.string :code, :null => false
      t.datetime :sent_at
      t.decimal :current_value, :precision => 8, :scale => 2, :null => false
      t.decimal :original_value, :precision => 8, :scale => 2, :null => false
      t.timestamps
    end
  end
end
