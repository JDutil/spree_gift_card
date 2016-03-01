Spree::ProductsController.class_eval do

  before_filter :redirect_gift_card, only: :show

  private

    def redirect_gift_card
      redirect_to new_gift_card_path and return false if @product.try :is_gift_card?
    end

end
