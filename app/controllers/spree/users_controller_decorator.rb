Spree::UsersController.class_eval do
  def gift_cards
    @show_all = params[:show_all] == "true"
    @gift_cards = current_spree_user.gift_cards.order(:expiration_date).
      reverse_order
    @gift_cards = @gift_cards.active unless @show_all
  end
end
