require 'spec_helper'

describe Spree::Calculator::GiftCardCalculator do

  let(:calculator) { Spree::Calculator::GiftCardCalculator.new }
  let(:gift_card) { create(:gift_card, variant: create(:variant, price: 25)) }
  let(:order) { mock_model Spree::Order, total: 100 }

  it '.description' do
    expect(Spree::Calculator::GiftCardCalculator.description).to eql('Gift Card Calculator')
  end

  describe '#compute' do
    context 'when current value of gift_card is 0' do
      before { gift_card.stub current_value: 0 }
      it "should compute 0 if current value is 0" do
        expect(calculator.compute(order, gift_card)).to eql 0
      end
    end

    context 'when order total less than current value' do
      before { gift_card.stub current_value: 120 }
      it "should compute 0 if current value is 0" do
        expect(calculator.compute(order, gift_card)).to eql -100
      end
    end

    context 'when order total greater than current value' do
      before { order.stub total: 125 }
      it "should compute 0 if current value is 0" do
        expect(calculator.compute(order, gift_card)).to eql -25
      end
    end
  end

end
