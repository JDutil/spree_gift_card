Spree::OrdersController.class_eval do

  before_action :assign_order_with_lock, only: [:apply_gift_card, :update]

  def apply_gift_card
    @order.gift_code = params[:order][:gift_code]
    apply_gift_code if @order.gift_code.present?

    redirect_to checkout_state_path(@order.state)
  end

end
