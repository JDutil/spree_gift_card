require 'spec_helper'

describe "Checkout" do

  before do
    create(:gift_card, code: "foobar", variant: create(:variant, price: 25))
    country = create(:country, name: "United States")
    create(:state, name: "Alaska", country: country)
    zone = create(:zone, zone_members: [Spree::ZoneMember.create(zoneable: country)])
    create(:shipping_method, zone: zone)
    create(:payment_method)
    create(:product, name: "RoR Mug", price: 30)
  end

  # Wait for Spree 1.2.x when promos & adjustments are also handled on the cart page.
  # context "on the cart page" do
  #   before do
  #     visit spree.root_path
  #     click_link "RoR Mug"
  #     click_button "add-to-cart-button"
  #   end
  # 
  #   it "can enter a valid gift code" do
  #     fill_in "Gift Code", :with => "onetwo"
  #     click_button "Update"
  #     page.should have_content("Gift code has been successfully applied to your order.")
  #   end
  # 
  #   it "cannot enter a gift code that was created after the order" do
  #     gift_card.update_column(:created_at, 1.day.from_now)
  #     fill_in "Gift Code", :with => "onetwo"
  #     click_button "Update"
  #     page.should have_content("The gift code you entered doesn't exist. Please try again.")
  #   end
  # end

  context "visitor makes checkout as guest without registration" do

    it "informs about an invalid gift code", :js => true do
      visit spree.root_path
      click_link "RoR Mug"
      click_button "add-to-cart-button"
      click_button "Checkout"

      # TODO not sure why registration page is ignored so just update order here.
      Spree::Order.last.update_column(:email, "spree@example.com")
      # fill_in "order_email", :with => "spree@example.com"
      # click_button "Continue"

      fill_in "First Name", :with => "John"
      fill_in "Last Name", :with => "Smith"
      fill_in "Street Address", :with => "1 John Street"
      fill_in "City", :with => "City of John"
      fill_in "Zip", :with => "01337"
      select "United States", :from => "Country"
      select "Alaska", :from => "order[bill_address_attributes][state_id]"
      fill_in "Phone", :with => "555-555-5555"
      check "Use Billing Address"

      # To shipping method screen
      click_button "Save and Continue"
      # To payment screen
      click_button "Save and Continue"

      fill_in "Gift code", :with => "coupon_codes_rule_man"
      click_button "Save and Continue"
      page.should have_content("The gift code you entered doesn't exist. Please try again.")
    end

    it "displays valid gift code's adjustment", :js => true do
      visit spree.root_path
      click_link "RoR Mug"
      click_button "add-to-cart-button"
      click_button "Checkout"

      # TODO not sure why registration page is ignored so just update order here.
      Spree::Order.last.update_column(:email, "spree@example.com")
      # fill_in "order_email", :with => "spree@example.com"
      # click_button "Continue"

      fill_in "First Name", :with => "John"
      fill_in "Last Name", :with => "Smith"
      fill_in "Street Address", :with => "1 John Street"
      fill_in "City", :with => "City of John"
      fill_in "Zip", :with => "01337"
      select "United States", :from => "Country"
      select "Alaska", :from => "order[bill_address_attributes][state_id]"
      fill_in "Phone", :with => "555-555-5555"
      check "Use Billing Address"

      # To shipping method screen
      click_button "Save and Continue"
      # To payment screen
      click_button "Save and Continue"

      fill_in "Gift code", :with => "foobar"
      click_button "Save and Continue"
      within "[data-hook='order_details_adjustments']" do
        page.should have_content("Gift Card")
        page.should have_content("-$25.00")
      end
    end

  end

end
