Spree::CheckoutController.class_eval do

  # TODO Apply gift code in a before filter if possible to avoid overriding the update method for easier upgrades?
  def update
    if @order.update_attributes(object_params)
      fire_event('spree.checkout.update')

      if defined?(Spree::Promo) and @order.coupon_code.present?
        event_name = "spree.checkout.coupon_code_added"
        if Spree::Promotion.exists?(:code       => @order.coupon_code,
                                    :event_name => event_name)

          fire_event(event_name, :coupon_code => @order.coupon_code)
          # If it doesn't exist, raise an error!
          # Giving them another chance to enter a valid coupon code
        else
          flash[:error] = t(:promotion_not_found)
          render :edit and return
        end
      end

      if @order.gift_code.present?
        if gift_card = Spree::GiftCard.find_by_code(@order.gift_code) and gift_card.order_activatable?(@order)
          fire_event('spree.checkout.gift_code_added', :gift_code => @order.gift_code)
          gift_card.apply(@order)
        else
          flash[:error] = t(:gift_code_not_found)
          render :edit and return
        end
      end

      if @order.next
        state_callback(:after)
      else
        flash[:error] = t(:payment_processing_failed)
        respond_with(@order, :location => checkout_state_path(@order.state))
        return
      end

      if @order.state == 'complete' || @order.completed?
        flash.notice = t(:order_processed_successfully)
        flash[:commerce_tracking] = 'nothing special'
        respond_with(@order, :location => completion_route)
      else
        respond_with(@order, :location => checkout_state_path(@order.state))
      end
    else
      respond_with(@order) { |format| format.html { render :edit } }
    end
  end

end
