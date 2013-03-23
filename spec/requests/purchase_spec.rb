require 'spec_helper'

feature "Purchase Gift Card", js: true do

  before do
    ## TODO seed helper for gc
    product = Spree::Product.new(available_on: Time.now, name: "Gift Card", is_gift_card: true, permalink: 'gift-card', price: 0)
    option_type = Spree::OptionType.new(name: "is-gift-card", presentation: "Value")
    product.option_types << option_type
    [25, 50, 75, 100].each do |value|
      option_value = Spree::OptionValue.new(name: value, presentation: "$#{value}")
      option_value.option_type = option_type
      variant = Spree::Variant.new(price: value.to_i, sku: "GIFTCERT#{value}", on_hand: 1000)
      variant.option_values << option_value
      product.variants << variant
    end
    product.save
    ## TODO seed helper for checkout requirements
    country = create(:country, name: "United States")
    create(:state, name: "Alaska", country: country)
    zone = create(:zone, zone_members: [Spree::ZoneMember.create(zoneable: country)])
    create(:shipping_method, zone: zone)
    create(:payment_method)
    create(:mail_method)
    ##
    Spree::GiftCard.count.should eql(0)
    ActionMailer::Base.deliveries = []
    visit spree.root_path
    click_link "Buy gift card"
  end

  scenario 'adding to cart with invalid information should display errors' do
    fill_in 'gift_card[email]', with: '@example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    select '$50.00', from: 'gift_card[variant_id]'
    click_button 'Add To Cart'
    page.should have_content('Email is invalid')
    Spree::GiftCard.count.should eql(0)
  end

  scenario 'adding to cart with valid information should checkout properly' do
    fill_in 'gift_card[email]', with: 'spree@example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    select '$50.00', from: 'gift_card[variant_id]'
    click_button 'Add To Cart'
    within '#line_items' do
      page.should have_content('Gift Card')
      Spree::GiftCard.count.should eql(1)
    end

    # TODO not sure why registration page is ignored so just update order here.
    Spree::Order.last.update_column(:email, "spree@example.com")
    click_button "Checkout"
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

    ActionMailer::Base.deliveries.size.should == 0
    click_button "Save and Continue"
    ActionMailer::Base.deliveries[1].subject.should eql('Spree Demo Site Gift Card')
    ActionMailer::Base.deliveries.size.should == 2 # Order Confirmation & Gift Card Delivery
  end

  scenario 'removing line item from cart should destroy gift card' do
    fill_in 'gift_card[email]', with: 'spree@example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    select '$50.00', from: 'gift_card[variant_id]'
    click_button 'Add To Cart'
    Spree::GiftCard.count.should eql(1)
    within '#line_items' do
      page.should have_content('Gift Card')
      find('a.delete').click
    end
    page.should_not have_content('Gift Card')
    Spree::GiftCard.count.should eql(0)
  end

end
