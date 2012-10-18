require 'spec_helper'

describe Spree::Order do

  it '#contains? should return false if variant is gift card' do
    pending
  end

  context '#finalize!' do

    let(:gift_card) { create(:gift_card, variant: create(:variant, price: 25)) }

    context 'when redeeming gift card' do
      it 'debits gift cards current value' do
        gift_card.current_value.should eql(25.0)
        order = create(:order_with_totals)
        order.line_items = [create(:line_item, order: order, price: 75, variant: create(:variant, price: 75))]
        order.reload # reload so line item is associated
        order.update!
        gift_card.apply(order)
        gift_card.reload.current_value.to_f.should eql(25.0)
        order.finalize!
        gift_card.reload.current_value.to_f.should eql(0.0)
      end
    end

    context 'when purchasing gift card' do
      it 'sends emails' do
        order = create(:order_with_totals)
        order.line_items = [create(:line_item, gift_card: gift_card, order: order, price: 25, variant: gift_card.variant)]
        order.reload # reload so line item is associated
        order.update!
        Spree::OrderMailer.stub_chain(:gift_card_email, :deliver).and_return(true)
        Spree::OrderMailer.should_receive(:gift_card_email).with(gift_card, order).once
        order.finalize!
      end
    end

  end

end
