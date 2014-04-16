require "spec_helper"

describe Spree::GiftCardMailer do
  describe ".gift_card_issued" do
    let(:gift_card) { create(:gift_card) }

    it 'sends email to Gift Card Email' do
      mail = Spree::GiftCardMailer.gift_card_issued gift_card
      mail.to.should == [gift_card.email]
    end
  end
end
