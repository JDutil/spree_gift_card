require 'spec_helper'

describe Spree::Payment do

  let(:order) { create(:completed_order_with_pending_payment) }

  describe 'gift_card_valid_state_transition?' do

    context 'valid state transition' do
      before do
        order.payments.first.state = 'completed' 
      end

      it 'is expected to return true' do
        expect(order.payments.first.gift_card_valid_state_transition?).to be true
      end
    end

    context 'invalid state transition' do
      before do
        order.payments.first.state = 'checkout' 
      end

      it 'is expected to return false' do
        expect(order.payments.first.gift_card_valid_state_transition?).to be false
      end
    end

  end

end
