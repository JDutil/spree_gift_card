require 'spec_helper'

describe Spree::LineItem do

  subject do
    line_item = FactoryGirl.build(:gift_card).line_item
    line_item.product.stub(:is_gift_card?) { true }
    line_item
  end

  it { should have_one(:gift_card).dependent(:destroy) }
  it { should validate_presence_of(:gift_card) }
  it { should validate_numericality_of(:quantity).is_less_than_or_equal_to(1) }

end
