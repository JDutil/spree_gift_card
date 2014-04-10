Spree::UsersController.class_eval do
  def gift_cards
    @show_all = params[:show_all] == "true"
    @gift_cards = current_spree_user.gift_cards.page(params[:page]).
      order(:expiration_date).reverse_order
    @gift_cards = @gift_cards.active unless @show_all

    @gift_cards.sort! do |a, b|
      comp = gc_sort_order[a.status] <=> gc_sort_order[b.status]
      comp.zero?? (b.expiration_date <=> a.expiration_date) : comp
    end
  end

  private
    def gc_sort_order
      {
        active: 1,
        redeemed: 2,
        expired: 3
      }
    end
end
