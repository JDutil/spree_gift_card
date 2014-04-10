Deface::Override.new(virtual_path: "spree/users/show",
                     name: "add_link_to_gift_cards",
                     insert_bottom: "[data-hook='account_summary']",
                     text: <<ERB)
<%= link_to Spree.t("view_my_gift_certificates"), account_gift_cards_path, class: "gift-cards-link" %>
ERB
