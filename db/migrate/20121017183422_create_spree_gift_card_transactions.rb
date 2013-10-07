class CreateSpreeGiftCardTransactions < ActiveRecord::Migration
  def change
    create_table :spree_gift_card_transactions do |t|
      t.decimal :amount, scale: 2, precision: 6
      t.belongs_to :gift_card
      t.belongs_to :order
      t.timestamps
    end
  end
end
