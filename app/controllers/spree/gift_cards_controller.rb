module Spree
  class GiftCardsController < Spree::BaseController
    helper 'spree/admin/base'

    def new
      find_gift_card_variants
      @gift_card = GiftCard.new
    end

    def create
      @gift_card = GiftCard.new(params[:gift_card])
      if @gift_card.save
        @order = current_order(true)
        line_item = @order.add_variant(@gift_card.variant, 1)
        @gift_card.line_item = line_item
        @gift_card.save
        redirect_to cart_path
      else
        find_gift_card_variants
        render :action => :new
      end
    end

    private

    def find_gift_card_variants
      gift_card_product_ids = Product.not_deleted.where(["is_gift_card = ?", true]).map(&:id)
      @gift_card_variants = Variant.where(["price > 0 AND product_id IN (?)", gift_card_product_ids]).order("price")
    end

  end
end
