require 'spec_helper'

describe "Checkout", js: true do

  let!(:country) { create(:country, :name => "United States of America",:states_required => true) }
  let!(:state) { create(:state, :name => "Alabama", :country => country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:mug) { create(:product, :name => "RoR Mug") }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:zone) { create(:zone) }

  before do
    create(:gift_card, code: "foobar", variant: create(:variant, price: 5))
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
      fill_in "order_gift_code", :with => "coupon_codes_rule_man"
      click_button "Apply"
      expect(page).to have_content("The gift code you entered doesn't exist. Please try again.")
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

      fill_in "order_gift_code", :with => "foobar"
      click_button "Apply"
      click_button "Save and Continue"

      within '#line-items' do
        page.should have_content("-$5.00")
      end
    end

  end

end
