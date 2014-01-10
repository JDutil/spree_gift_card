Spree::OrdersController.class_eval do

  durably_decorate :update, mode: 'soft', sha: 'b5f4112738f931e0aa0b1b6cc4071c27d9d5b0a0' do
    @order = current_order
    if @order.update_attributes(params[:order])
      render :edit and return unless apply_coupon_code if defined?(Spree::Promo)
      render :edit and return unless apply_gift_code

      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      fire_event('spree.order.contents_changed')
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

end
