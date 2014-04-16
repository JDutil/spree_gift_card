Deface::Override.new(
  virtual_path: 'spree/admin/shared/_configuration_menu',
  name: "add_gift_card_link_to_sidebar",
  insert_bottom: '[data-hook="admin_configurations_sidebar_menu"]',
  partial: 'spree/admin/shared/gift_card_sidebar_link'
)

