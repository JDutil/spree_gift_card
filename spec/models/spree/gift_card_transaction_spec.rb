require 'spec_helper'

describe Spree::GiftCardTransaction do
  it {should belong_to(:gift_card)}
  it {should belong_to(:order)}
  it {should validate_presence_of(:amount)}
  it {should validate_presence_of(:gift_card)}
  it {should validate_presence_of(:order)}
end
