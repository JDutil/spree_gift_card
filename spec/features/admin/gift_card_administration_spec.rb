require 'spec_helper'

feature "Admin Gift Card Administration", js: true do

  stub_authorization!

  before do
    ## TODO seed helper for gc
    product = Spree::Product.new(available_on: Time.now, name: "Gift Card", is_gift_card: true, slug: 'gift-card', price: 0, shipping_category_id: create(:shipping_category).id)
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
  end

  scenario 'creating gift card' do
    visit spree.admin_gift_cards_path
    expect(Spree::GiftCard.count).to eql(0)
    click_link 'New Gift Card'
    fill_in 'gift_card[email]', with: 'spree@example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    select '$50.00', from: 'Value'
    click_button 'Create'
    expect(page).to have_content('You have successfully created the gift card.')
    within 'table.index' do
      expect(page).to have_content('First Last')
      expect(Spree::GiftCard.count).to eql(1)
    end
  end

  scenario 'creating gift card with invalid data renders new form with errors' do
    visit spree.admin_gift_cards_path
    expect(Spree::GiftCard.count).to eql(0)
    click_link 'New Gift Card'
    fill_in 'gift_card[email]', with: 'example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    select '$50.00', from: 'Value'
    click_button 'Create'
    expect(page).to have_css('.field_with_errors #gift_card_email')
    expect(Spree::GiftCard.count).to eql(0)
  end

  scenario 'deleting gift card' do
    create :gift_card, name: 'First Last'
    visit spree.admin_gift_cards_path
    within 'table.index' do
      expect(page).to have_content('First Last')
      find('[data-action="remove"]').click
      page.driver.browser.switch_to.alert.accept
    end
    sleep 1
    expect(Spree::GiftCard.count).to eql(0)
  end

  scenario 'updating gift card' do
    create :gift_card, name: 'Testing'
    visit spree.admin_gift_cards_path
    find('[data-action="edit"]').click
    fill_in 'gift_card[email]', with: 'spree@example.com'
    fill_in 'gift_card[name]', with: 'First Last'
    fill_in 'gift_card[note]', with: 'Test message.'
    click_button 'Update'
    expect(page).to have_content("Gift card \"First Last\" has been successfully updated!")
    within 'table.index' do
      expect(page).to have_content('First Last')
    end
  end

end
