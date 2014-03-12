class UpgradeGiftCardAdjustments < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.column_exists?(:spree_adjustments, :originator_type)

      # Temporarily make originator association available
      Spree::Adjustment.class_eval do
        belongs_to :originator, polymorphic: true
      end

      # Gift Card adjustments have their sources altered
      Spree::Adjustment.where(:originator_type => "Spree::GiftCard").find_each do |adjustment|
        adjustment.source = adjustment.originator
        adjustment.save
      end
    end
  end
end
