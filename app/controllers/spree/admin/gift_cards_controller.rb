module Spree
  module Admin
    class GiftCardsController < Spree::Admin::ResourceController
      before_filter :find_gift_card_variants, :except => [:destroy]

      def create
        @object.attributes = gift_card_params
        if @object.save
          flash[:success] = Spree.t(:successfully_created_gift_card)
          redirect_to admin_gift_cards_path
        else
          render :new
        end
      end

      private
      def collection
        Spree::GiftCard.order("created_at desc").page(params[:page]).per(Spree::Config[:orders_per_page])
      end

      def find_gift_card_variants
        gift_card_product_ids = Product.not_deleted.where(is_gift_card: true).pluck(:id)
        @gift_card_variants = Variant.joins(:prices).where(["amount > 0 AND product_id IN (?)", gift_card_product_ids]).order("amount")
      end

      def gift_card_params
        params.require(:gift_card).permit(:email, :name, :note, :value, :variant_id)
      end

    end
  end
end
