if defined? Devise
  Deface::Override.new(
    virtual_path: "spree/admin/users/show",
    name: "add_create_gift_card_button_to_show",
    insert_after: "table",
    partial: "spree/admin/users/gift_card_buttons"
  )
end
