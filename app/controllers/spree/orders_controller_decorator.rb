Spree::OrdersController.class_eval do

  # TODO Apply gift code in a before filter if possible to avoid overriding the update method for easier upgrades?
  def update
    @order = current_order
    if @order.update_attributes(params[:order])
      if defined?(Spree::Promo) and @order.coupon_code.present?
        if apply_coupon_code
          flash[:notice] = t(:coupon_code_applied)
        else
          flash[:error] = t(:promotion_not_found)
          render :edit and return
        end
      end
      if @order.gift_code.present?
        if apply_gift_code
          flash[:notice] = t(:gift_code_applied)
        else
          flash[:error] = t(:gift_code_not_found)
          render :edit and return
        end
      end
      @order.line_items = @order.line_items.select { |li| li.quantity > 0 }
      fire_event('spree.order.contents_changed')
      if params[:checkout]
        respond_with(@order) { |format| format.html { redirect_to checkout_path } }
      else
        respond_with(@order) { |format| format.html { redirect_to cart_path } }
      end
    else
      respond_with(@order)
    end
  end

  private

    def apply_gift_code
      return false if @order.gift_code.blank?
      if gift_card = Spree::GiftCard.find_by_code(@order.gift_code) and gift_card.order_activatable?(@order)
        fire_event('spree.checkout.gift_code_added', :gift_code => @order.gift_code)
        gift_card.apply(@order)
        return true
      else
        return false
      end
    end

end
