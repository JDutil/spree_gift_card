require 'spec_helper'

feature "Purchase Gift Card", js: true do

  let!(:country) { create(:country, :name => "United States of America",:states_required => true) }
  let!(:state) { create(:state, :name => "Alabama", :country => country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:mug) { create(:product, :name => "RoR Mug") }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:zone) { create(:zone) }

  before do
    ## TODO seed helper for gc
    product = Spree::Product.new(available_on: Time.now, name: "Gift Card", is_gift_card: true, slug: 'gift-card', price: 0, shipping_category_id: shipping_method.shipping_categories.first.id)
    option_type = Spree::OptionType.new(name: "is-gift-card", presentation: "Value")
    product.option_types << option_type
    [25, 50, 75, 100].each do |value|
      option_value = Spree::OptionValue.new(name: value, presentation: "$#{value}")
      option_value.option_type = option_type
      variant = Spree::Variant.new(price: value.to_i, sku: "GIFTCERT#{value}")
      variant.option_values << option_value
      product.variants << variant
    end
    product.save

    expect(Spree::GiftCard.count).to eql(0)
    ActionMailer::Base.deliveries = []
    visit spree.root_path
    click_link "Buy gift card"

    @message_delivery =  double(ActionMailer::MessageDelivery)
    @delivery_job =  double(ActionMailer::DeliveryJob)
    allow(Spree::OrderMailer).to receive(:confirm_email).and_return(@message_delivery)
    allow(@message_delivery).to receive(:deliver_later).and_return(@delivery_job)
  end

  scenario 'adding to cart with invalid information should display errors' do
    fill_in 'gift_card[email]', with: '@example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    select '$50.00', from: 'gift_card[variant_id]'
    click_button 'Add To Cart'
    expect(page).to have_content('Email is invalid')
    expect(Spree::GiftCard.count).to eql(0)
  end

  scenario 'adding to cart with valid information should checkout properly' do
    fill_in 'gift_card[email]', with: 'spree@example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    select '$50.00', from: 'gift_card[variant_id]'
    click_button 'Add To Cart'

    within '#line_items' do
      expect(page).to have_content('Gift Card')
      expect(Spree::GiftCard.count).to eql(1)
    end

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
    choose "Check"
    click_button "Save and Continue"
    expect(page).to have_content(Spree::Order.last.number)
  end

  scenario 'removing line item from cart should destroy gift card' do
    fill_in 'gift_card[email]', with: 'spree@example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    select '$50.00', from: 'gift_card[variant_id]'
    click_button 'Add To Cart'
    expect(Spree::GiftCard.count).to eql(1)
    within '#line_items' do
      expect(page).to have_content('Gift Card')
      find('a.delete').click
    end
    expect(page).not_to have_content('Gift Card')
    expect(Spree::GiftCard.count).to eql(0)
  end

end
