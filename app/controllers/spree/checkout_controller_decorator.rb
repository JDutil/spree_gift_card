Spree::CheckoutController.class_eval do

  Spree::PermittedAttributes.checkout_attributes << :gift_code

  def update
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      if @order.gift_code.present?
        render :edit and return unless apply_gift_code
      end

      @order.temporary_address = (params[:save_user_address]).blank?

      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state)
      end

      if @order.completed?
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end

  end

end
