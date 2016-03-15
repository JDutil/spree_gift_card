require 'spec_helper'

describe Spree::LineItem do

  subject do
    line_item = FactoryGirl.build(:gift_card).line_item
    allow(line_item.product).to receive(:is_gift_card?).and_return(true)
    line_item
  end

  it { is_expected.to have_one(:gift_card).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:gift_card) }
  it { is_expected.to validate_numericality_of(:quantity).is_less_than_or_equal_to(1) }

end
