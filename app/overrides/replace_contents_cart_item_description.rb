Deface::Override.new(:virtual_path => "spree/orders/_line_item",
                     :name => "replace_contents_cart_item_description",
                     :insert_bottom => "[data-hook='cart_item_description']",
                     :partial => 'spree/orders/line_item_gift_certificate_info',
                     :disabled => false,
                     :original => '95a090c709b76195844a3e0019062916e7595109')
