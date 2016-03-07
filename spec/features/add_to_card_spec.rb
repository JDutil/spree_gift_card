require 'spec_helper'

describe "Add to Cart", js: true do
  let(:product) { create :product, is_gift_card: true }
  let!(:variant) { create :variant, product: product }

  before do
    visit spree.root_path
    click_link 'Buy gift card'
    fill_in 'gift_card[email]', with: 'test@email.com'
    fill_in 'gift_card[name]', with: 'nom nom'
    click_button 'Add To Cart'
  end

  it 'has the correct total' do
    expect(page.find('.cart-total').text).to eq 'Total $19.99'
  end

  it 'contains number of items' do
    expect(page).to have_content("(1)")
  end

end
