module Spree
  class GiftCardsController < Spree::StoreController

    def new
      find_gift_card_variants
      @gift_card = GiftCard.new
    end

    def create
      begin
        # Wrap the transaction script in a transaction so it is an atomic operation
        Spree::GiftCard.transaction do
          @gift_card = GiftCard.new(gift_card_params)
          @gift_card.save!
          # Create line item
          line_item = LineItem.new(quantity: 1)
          line_item.gift_card = @gift_card
          line_item.variant = @gift_card.variant
          line_item.price = @gift_card.variant.price
          # Add to order
          order = current_order(create_order_if_necessary: true)
          order.line_items << line_item
          line_item.order=order
          order.save!
          # Save gift card
          @gift_card.line_item = line_item
          @gift_card.save!
        end
        redirect_to cart_path
      rescue ActiveRecord::RecordInvalid
        find_gift_card_variants
        render :action => :new
      end
    end

    private

    def find_gift_card_variants
      gift_card_product_ids = Product.not_deleted.where(is_gift_card: true).pluck(:id)
      @gift_card_variants = Variant.joins(:prices).where(["amount > 0 AND product_id IN (?)", gift_card_product_ids]).order("amount")
    end

    def gift_card_params
      params.require(:gift_card).permit(:email, :name, :note, :variant_id)
    end

  end
end
