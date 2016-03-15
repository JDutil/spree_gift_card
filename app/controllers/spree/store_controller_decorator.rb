Spree::StoreController.class_eval do

  protected

    def apply_gift_code
      if params[:order] && params[:order][:gift_code]
        @order.coupon_code = params[:order][:gift_code]
      end
      return true if @order.gift_code.blank?
      gift_card = Spree::GiftCard.find_by(code: @order.gift_code)

      if !(gift_card && gift_card.order_activatable?(@order))
        flash[:error] = Spree.t(:gift_code_not_found)
        return
      end

      if gift_card.apply(@order)
        flash[:success] = Spree.t(:gift_code_applied)
      else
        flash[:error] = Spree.t(:gift_code_already_applied)
      end
    end

end
