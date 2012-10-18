require 'spec_helper'

describe Spree::GiftCard do

  it {should have_many(:transactions)}

  it {should validate_presence_of(:current_value)}
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:original_value)}
  it {should validate_presence_of(:name)}

  it "should generate code before create" do
    card = Spree::GiftCard.create(:email => "test@mail.com", :name => "John", :variant_id => create(:variant).id)
    card.code.should_not be_nil
  end

  it "should set current_value and original_value before create" do
    card = Spree::GiftCard.create(:email => "test@mail.com", :name => "John", :variant_id => create(:variant).id)
    card.current_value.should_not be_nil
    card.original_value.should_not be_nil
  end

  it 'should only have certain attributes be accessible' do
    subject.class.accessible_attributes.to_a.should eql([
      '', # WTF? no idea why a blank value is being added...
      'email',
      'name',
      'note',
      'variant_id',
      'calculator_type',
      'calculator_attributes'
    ])
  end

  context '#apply' do
    let(:gift_card) { create(:gift_card, variant: create(:variant, price: 25)) }

    context 'for order total larger than gift card amount' do
      it 'creates adjustment for full amount' do
        order = create(:order_with_totals)
        create(:line_item, order: order, price: 75, variant: create(:variant, price: 75))
        order.reload # reload so line item is associated
        order.update!
        gift_card.apply(order)
        order.adjustments.find_by_originator_id_and_originator_type(gift_card.id, gift_card.class.to_s).amount.to_f.should eql(-25.0)
      end
    end

    context 'for order total smaller than gift card amount' do
      it 'creates adjustment for order total' do
        order = create(:order_with_totals)
        order.reload # reload so line item is associated
        order.update! # update so order calculates totals
        gift_card.apply(order)
        # default line item is priced at 10
        order.adjustments.find_by_originator_id_and_originator_type(gift_card.id, gift_card.class.to_s).amount.to_f.should eql(-10.0)
      
        pending 'test should also have tax & shipping...'
      end
    end
  end

end
