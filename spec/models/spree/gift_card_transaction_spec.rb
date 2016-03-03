require 'spec_helper'

describe Spree::GiftCardTransaction do
  it { is_expected.to belong_to(:gift_card) }
  it { is_expected.to belong_to(:order) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:gift_card) }
  it { is_expected.to validate_presence_of(:order) }
end
