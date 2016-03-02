require 'spec_helper'

describe Spree::Calculator::GiftCardCalculator do

  let(:calculator) { Spree::Calculator::GiftCardCalculator.new }
  let(:gift_card) { create(:gift_card, variant: create(:variant, price: 25)) }
  let(:order) { mock_model Spree::Order, adjustments: [], item_total: 10, ship_total: 5, additional_tax_total: 1 }

  it '.description' do
    expect(Spree::Calculator::GiftCardCalculator.description).to eql('Gift Card Calculator')
  end

  describe '#compute' do
    it "should compute 0 if current value is 0" do
      gift_card.stub :current_value => 0
      expect(calculator.compute(order, gift_card)).to eql 0
    end

    it "should compute amount correctly when order total less than current value" do
      expect(calculator.compute(order, gift_card)).to eql -16
    end

    it "should compute amount correctly when order total greater than current value" do
      order.stub :item_total => 25
      expect(calculator.compute(order, gift_card)).to eql -25
    end
  end

end
