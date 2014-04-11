require 'spec_helper'

describe Spree::UsersController do
  describe "GET gift_cards" do
    subject { get :gift_cards, use_route: :spree }

    let!(:user) { create(:user) }
    let!(:gift_card) { create(:gift_card, user: user) }
    let!(:expired_gc) { create(:expired_gc, user: user) }

    before { allow(controller).to receive(:current_spree_user).and_return(user) }

    it { should render_template(:gift_cards) }
    it { should be_success }

    describe "sorting" do
      subject { get :gift_cards, use_route: :spree, show_all: "true" }

      let!(:gift_card_2) { create :gift_card, user: user, expiration_date: Time.current + 1.year }
      let!(:redeemed_gc) { create :redeemed_gc, user: user }

      it "sorts gift_cards by status, and then expiration_date" do
        subject
        expect(assigns(:gift_cards).count).to eq 4
        expect(assigns(:gift_cards).first).to eq gift_card_2
        expect(assigns(:gift_cards)[1]).to eq gift_card
        expect(assigns(:gift_cards)[-2]).to eq redeemed_gc
        expect(assigns(:gift_cards).last).to eq expired_gc
      end
    end

    context "when show_all query param isn't true" do
      it "doesn't include expired gift cards" do
        subject
        expect(assigns(:gift_cards).count).to eq 1
        expect(assigns(:gift_cards)).to_not include(expired_gc)
      end
    end

    context "when show_all query param is true" do
      subject { get :gift_cards, show_all: "true",
                use_route: :spree }

      it "includes expired gift cards as well" do
        subject
        expect(assigns(:gift_cards).count).to eq 2
        expect(assigns(:gift_cards)).to include(expired_gc)
      end
    end
  end
end
