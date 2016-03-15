require 'spec_helper'

describe Spree::Order do

  let(:gift_card) { create(:gift_card, variant: create(:variant, price: 25, product: create(:product, is_gift_card: true))) }

  context '#finalize!' do

    context 'when redeeming gift card' do
      it 'debits gift cards current value' do
        expect(gift_card.current_value).to eql(25.0)
        order = create(:order_with_totals)
        order.line_items = [create(:line_item, order: order, price: 75, variant: create(:variant, price: 75))]
        order.reload # reload so line item is associated
        order.update!
        gift_card.apply(order)
        expect(gift_card.reload.current_value.to_f).to eql(25.0)
        order.finalize!
        expect(gift_card.reload.current_value.to_f).to eql(0.0)
      end
    end

    context "with other credits" do
      it "does not let the order total fall below zero" do
        order = create(:order_with_totals)
        order.line_items = [create(:line_item, order: order, price: 20, variant: create(:variant, price: 20))]
        order.adjustments.create(:label => I18n.t('spree.store_credit') , :amount => -5)
        order.reload
        order.update!
        gift_card.apply(order)
        expect(order.total.to_f).to eql(0.0)
      end
    end

  end

end
