Spree::StoreController.class_eval do

  protected

    def apply_gift_code
      return true if @order.gift_code.blank?
      if gift_card = Spree::GiftCard.find_by_code(@order.gift_code) and gift_card.order_activatable?(@order)
        fire_event('spree.checkout.gift_code_added', :gift_code => @order.gift_code)
        gift_card.apply(@order)
        flash[:notice] = t(:gift_code_applied)
        return true
      else
        flash[:error] = t(:gift_code_not_found)
        return false
      end
    end

end
