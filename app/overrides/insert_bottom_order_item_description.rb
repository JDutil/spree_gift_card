Deface::Override.new(:virtual_path => "spree/shared/_order_details",
                     :name => "insert_bottom_order_item_description",
                     :insert_bottom => "[data-hook='order_item_description']",
                     :partial => 'spree/orders/item_gift_certificate_info',
                     :disabled => false)
