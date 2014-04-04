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

    context "when show_all query param is absent" do
      it "does not include expired gift cards" do
        subject
        expect(assigns(:gift_cards).count).to eq 1
        expect(assigns(:gift_cards)).to_not include(expired_gc)
      end
    end

    context "when show_all query param is passed in" do
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
