require 'spec_helper'

describe Spree::Calculator::GiftCard do

  let(:calculator) { Spree::Calculator::GiftCard.new }
  let(:gift_card) { create(:gift_card, variant: create(:variant, price: 25)) }
  let(:order) { mock_model Spree::Order, adjustments: [], item_total: 10, ship_total: 5, tax_total: 1 }

  it '.description' do
    Spree::Calculator::GiftCard.description.should eql('Gift Card Calculator')
  end

  describe '#compute' do
    it "should compute 0 if current value is 0" do
      gift_card.stub :current_value => 0
      calculator.compute(order, gift_card).should == 0
    end

    it "should compute amount correctly when order total less than current value" do
      calculator.compute(order, gift_card).should == -16
    end

    it "should compute amount correctly when order total greater than current value" do
      order.stub :item_total => 25
      calculator.compute(order, gift_card).should == -25
    end
  end

end
