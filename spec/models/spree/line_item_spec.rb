require 'spec_helper'

describe Spree::LineItem do

  it {should have_one(:gift_card).dependent(:destroy) }

  it 'should validate_numericality_of(:quantity).less_than_or_equal_to(1)' do
    pending
  end

  it 'should validate gift presence if product is gift card' do
    pending
  end

end
