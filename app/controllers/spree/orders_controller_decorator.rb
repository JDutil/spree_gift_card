Spree::OrdersController.class_eval do

  before_action :assign_order_with_lock, only: [:apply_gift_card, :update]

  def apply_gift_card
    @order.assign_attributes(order_gift_code_params)
    apply_gift_code if @order.gift_code.present?

    redirect_to checkout_state_path(@order.state)
  end

  private
    def order_gift_code_params
      params.require(:order).permit(:gift_code)
    end
end
