Spree::CheckoutController.class_eval do

  Spree::PermittedAttributes.checkout_attributes << :gift_code

  durably_decorate :update, mode: 'soft', sha: '9774bcd294f748bd6185a0c8f7d518e624b99ff7' do
    if @order.update_from_params(params, permitted_checkout_attributes)
      if @order.gift_code.present?
        render :edit and return unless apply_gift_code
      end

      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      if @order.completed?
        session[:order_id] = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end

  end

end
