require_dependency 'spree/calculator'

module Spree
  class Calculator::GiftCardCalculator < Calculator
    def self.description
      Spree.t(:gift_card_calculator)
    end

    def compute(order, gift_card)
      [order.total, gift_card.current_value].min * -1
    end

  end
end
