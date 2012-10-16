Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "insert_bottom_admin_product_form_right",
                     :insert_bottom => "[data-hook='admin_product_form_right']",
                     :partial => %q{spree/admin/products/gift_card_fields},
                     :disabled => false)
