Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "insert_bottom_sidebar",
                     :insert_bottom => "#sidebar, [data-hook='sidebar']",
                     :text => %q{<%= link_to t("buy_gift_card"), new_gift_card_path, :class => 'button' %>},
                     :disabled => false,
                     :original => '2f11ce271ae3b346b9fc6a927598ad6d6d6a1885')
