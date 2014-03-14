Spree::StoreController.class_eval do

  protected

    def apply_gift_code
      if params[:order] && params[:order][:gift_code]
        @order.coupon_code = params[:order][:gift_code]
      end
      return true if @order.gift_code.blank?
      if gift_card = Spree::GiftCard.find_by_code(@order.gift_code) and gift_card.order_activatable?(@order)
        gift_card.apply(@order)
        flash[:success] = Spree.t(:gift_code_applied)
        return true
      else
        flash[:error] = Spree.t(:gift_code_not_found)
        return false
      end
    end

end
