module Spree
  module Admin
    class GiftCardsController < Spree::Admin::ResourceController
      before_filter :find_gift_card_variants, :except => [:destroy]

      def update
        @object.attributes = gift_card_params
        @object.current_value = @object.original_value
        if params[:restrict_user]
          return unless handle_restricted_user
        end

        if @object.save
          flash[:success] = flash_message_for(@object, :successfully_updated)
          redirect_to admin_gift_cards_path
        else
          render :edit
        end
      end

      def create
        @object.attributes = gift_card_params
        @object.current_value = @object.original_value
        if params[:restrict_user]
          return unless handle_restricted_user
        end

        if @object.save
          Spree::GiftCardMailer.gift_card_issued(@object).deliver
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

      def handle_restricted_user
        user = Spree.user_class.find_by(email: @object.email)

        if user
          @object.user_id = user.id
          true
        else
          action = params[:action] == "create" ? :new : :edit
          flash[:error] = Spree.t(:could_not_find_user)
          render action
          false
        end
      end

      def find_gift_card_variants
        gift_card_product_ids = Product.not_deleted.where(is_gift_card: true).pluck(:id)
        @gift_card_variants = Variant.joins(:prices).where(["amount > 0 AND product_id IN (?)", gift_card_product_ids]).order("amount")
      end

      def gift_card_params
        params[object_name].permit(:email, :original_value, :name, :note, :value, :variant_id)
      end
    end
  end
end
