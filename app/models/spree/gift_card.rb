require 'spree/core/validators/email'

module Spree
  class GiftCard < ActiveRecord::Base

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

    belongs_to :variant
    belongs_to :line_item

    validates :current_value,      presence: true
    validates :email, email: true, presence: true
    validates :original_value,     presence: true
    validates :name,               presence: true
    validates :token,              presence: true, uniqueness: true

    before_validation :generate_token, on: :create
    before_validation :set_values, on: :create
    before_validation :set_calculator # Goes after set_values to ensure current_value is set.

    attr_accessible :email, :name, :note, :variant_id

    calculated_adjustments

    def apply(order)
      # Nothing to do if the gift card is already associated with the order
      return if order.gift_credit_exists?(self)
      # order.adjustments.gift_card.reload.clear
      order.update!
      create_adjustment(I18n.t(:gift_card), order, order)
      order.update!
      # TODO: if successful we should update preferred amount or should that be done elsewhere?  Might make sense to create a new calculator that does the updating
    end

    def price
      self.line_item ? self.line_item.price * self.line_item.quantity : self.variant.price
    end

    def order_activatable?(order)
      order &&
      created_at.to_i < order.created_at.to_i &&
      !UNACTIVATABLE_ORDER_STATES.include?(order.state)
    end

    private

    def generate_token
      until self.token.present? && self.class.where(token: self.token).count == 0
        self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
      end
    end

    def set_calculator
      self.calculator = Spree::Calculator::FlatRate.new({preferred_amount: -(self.current_value || 0)})
    end

    def set_values
      self.current_value  = self.variant.try(:price)
      self.original_value = self.variant.try(:price)
    end

  end
end
