require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    class GiftCard < Calculator

      def self.description
        Spree.t(:gift_card_calculator)
      end

      def compute(order, gift_card)
        # Ensure a negative amount which does not exceed the sum of the order's item_total, ship_total, and 
        # tax_total, minus other credits.
        credits = order.adjustments.select{|a|a.amount < 0 && a.source_type != 'Spree::GiftCard'}.map(&:amount).sum
        [(order.item_total + order.ship_total + order.additional_tax_total + credits), gift_card.current_value].min * -1
      end

    end
  end
end
