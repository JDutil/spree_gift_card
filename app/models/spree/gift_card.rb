require 'spree/core/validators/email'

module Spree
  class GiftCard < ActiveRecord::Base

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

    belongs_to :user, class_name: Spree.user_class.to_s
    belongs_to :variant
    belongs_to :line_item

    has_many :transactions, class_name: 'Spree::GiftCardTransaction'

    validates :code,               presence: true, uniqueness: true
    validates :current_value,      presence: true
    validates :email, email: true, presence: true
    validates :name,               presence: true
    validates :original_value,     presence: true

    before_validation :generate_code, on: :create
    before_validation :set_calculator, on: :create
    before_validation :set_values, on: :create

    scope :active, -> () { where('current_value != 0.0 AND expiration_date > ?', Time.now) }

    include Spree::Core::CalculatedAdjustments

    def self.sortable_attributes
      [
        ["Creation Date", "created_at"],
        ["Expiration Date", "expiration_date"],
      ]
    end

    def apply(order)
      # Nothing to do if the gift card is already associated with the order
      return if order.gift_credit_exists?(self)
      if is_valid_user?(order.user)
        order.update!
        create_adjustment(Spree.t(:gift_card), order, order, true)
        order.update!
        true
      else
        false
      end
    end

    # Calculate the amount to be used when creating an adjustment
    def compute_amount(calculable)
      self.calculator.compute(calculable, self)
    end

    def debit(amount, order)
      raise 'Cannot debit gift card by amount greater than current value.' if (self.current_value - amount.to_f.abs) < 0
      transaction = self.transactions.build
      transaction.amount = amount
      transaction.order  = order
      self.current_value = self.current_value - amount.abs
      self.save
    end

    def price
      if self.line_item
        return self.line_item.price * self.line_item.quantity
      elsif self.variant
        return self.variant.price
      else
        return self.current_value
      end
    end

    def order_activatable?(order)
      order &&
      created_at < order.created_at &&
      current_value > 0 &&
      !UNACTIVATABLE_ORDER_STATES.include?(order.state) &&
      is_valid_user?(order.user)
    end

    private

    def is_valid_user?(user)
      if gc_user = self.user_id
        return user.id == gc_user
      end

      true
    end

    def generate_code
      until self.code.present? && self.class.where(code: self.code).count == 0
        self.code = Digest::SHA1.hexdigest([Time.now, rand].join)
      end
    end

    def set_calculator
      self.calculator = Spree::Calculator::GiftCard.new
    end

    def set_values
      if self.variant
        self.current_value  = self.variant.try(:price)
        self.original_value = self.variant.try(:price)
      end
    end
  end
end
