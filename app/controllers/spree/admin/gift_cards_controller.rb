module Spree
  module Admin
    class GiftCardsController < Spree::Admin::ResourceController

      def create
        if @gift_card.save
          flash[:success] = I18n.t(:successfully_created_gift_card)
          redirect_to admin_gift_cards_path
        else
          find_gift_card_variants
          render :new
        end
      end

      def edit
        find_gift_card_variants
      end

      def new
        find_gift_card_variants
      end

      private

      def find_gift_card_variants
        gift_card_product_ids = Product.not_deleted.where(is_gift_card: true).pluck(:id)
        @gift_card_variants = Variant.joins(:prices).where(["amount > 0 AND product_id IN (?)", gift_card_product_ids]).order("amount")
      end

    end
  end
end
