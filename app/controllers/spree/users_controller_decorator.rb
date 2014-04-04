Spree::UsersController.class_eval do
  def gift_cards
    @gift_cards = current_spree_user.gift_cards.order(:expiration_date)
    @gift_cards = @gift_cards.active unless params[:show_all]
  end
end
