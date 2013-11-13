require 'spec_helper'

describe "Checkout", js: true do

  let!(:country) { create(:country, :name => "United States of America",:states_required => true) }
  let!(:state) { create(:state, :name => "Alabama", :country => country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:mug) { create(:product, :name => "RoR Mug") }
  let!(:payment_method) { create(:payment_method) }
  let!(:zone) { create(:zone) }

  before do
    create(:gift_card, code: "foobar", variant: create(:variant, price: 25))
  end

  context "on the cart page" do
    before do
      visit spree.root_path
      click_link "RoR Mug"
      click_button "add-to-cart-button"
    end

    it "can enter a valid gift code" do
      fill_in "order[gift_code]", :with => "foobar"
      click_button "Update"
      page.should have_content("Gift code has been successfully applied to your order.")
      within '#cart_adjustments' do
        page.should have_content("Gift Card")
        page.should have_content("-$19.99")
      end
    end

    it "cannot enter a gift code that was created after the order" do
      Spree::GiftCard.first.update_attribute(:created_at, 1.day.from_now)
      fill_in "order[gift_code]", :with => "foobar"
      click_button "Update"
      page.should have_content("The gift code you entered doesn't exist. Please try again.")
    end
  end

  context "visitor makes checkout as guest without registration" do

    it "informs about an invalid gift code" do
      visit spree.root_path
      click_link "RoR Mug"
      click_button "add-to-cart-button"

      # TODO not sure why registration page is ignored so just update order here.
      Spree::Order.last.update_column(:email, "spree@example.com")
      click_button "Checkout"
      # fill_in "order_email", :with => "spree@example.com"
      # click_button "Continue"

      within '#billing' do
        fill_in "First Name", :with => "John"
        fill_in "Last Name", :with => "Smith"
        fill_in "order_bill_address_attributes_address1", :with => "1 John Street"
        fill_in "City", :with => "City of John"
        fill_in "Zip", :with => "01337"
        select "United States of America", :from => "Country"
        select "Alabama", :from => "order[bill_address_attributes][state_id]"
        fill_in "Phone", :with => "555-555-5555"
      end
      check "Use Billing Address"

      # To shipping method screen
      click_button "Save and Continue"
      # To payment screen
      click_button "Save and Continue"

      fill_in "Gift code", :with => "coupon_codes_rule_man"
      click_button "Save and Continue"
      page.should have_content("The gift code you entered doesn't exist. Please try again.")
    end

    it "displays valid gift code's adjustment" do
      visit spree.root_path
      click_link "RoR Mug"
      click_button "add-to-cart-button"

      # TODO not sure why registration page is ignored so just update order here.
      Spree::Order.last.update_column(:email, "spree@example.com")
      click_button "Checkout"
      # fill_in "order_email", :with => "spree@example.com"
      # click_button "Continue"

      within '#billing' do
        fill_in "First Name", :with => "John"
        fill_in "Last Name", :with => "Smith"
        fill_in "order_bill_address_attributes_address1", :with => "1 John Street"
        fill_in "City", :with => "City of John"
        fill_in "Zip", :with => "01337"
        select "United States of America", :from => "Country"
        select "Alabama", :from => "order[bill_address_attributes][state_id]"
        fill_in "Phone", :with => "555-555-5555"
      end
      check "Use Billing Address"

      # To shipping method screen
      click_button "Save and Continue"
      # To payment screen
      click_button "Save and Continue"

      fill_in "Gift code", :with => "foobar"
      click_button "Save and Continue"

      within '#order-charges' do
        page.should have_content("Gift Card")
        page.should have_content("-$19.99")
      end
    end

  end

end
